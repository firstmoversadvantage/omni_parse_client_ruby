# frozen_string_literal: true

require 'net/http'

module OmniparseClient
  # Connection module
  module Connection
    class RetriesLimitReached < StandardError; end

    attr_reader :api_key, :port, :version, :host

    DEFAULT_URL           = 'www.omniparse.com'
    DEFAULT_PORT          = 443
    DEFAULT_VERSION       = '/api/v1'
    # Retries count if network error occurs
    MAX_RETRIES_COUNT     = ENV['OMNI_MAX_RETRIES_COUNT']&.to_i || 5
    # Time in seconds for consequent delays for reconnection
    RETRIES_DELAYS_ARRAY  =
      ENV['OMNI_RETRIES_DELAYS_ARRAY']&.split(',')&.map(&:to_i) ||
      [5, 30, 2 * 60, 10 * 60, 30 * 60].freeze
    EXCEPTIONS_INCLUDING_MESSAGES = [
      SocketError,
      Net::OpenTimeout
    ].freeze
    EXCEPTIONS_EXCLUDING_MESSAGES = [
      Net::HTTPFatalError
    ].freeze
    CLIENT_ERRORS = [
      Net::HTTPInternalServerError,
      Net::HTTPNotImplemented,
      Net::HTTPBadGateway,
      Net::HTTPServiceUnavailable,
      Net::HTTPGatewayTimeout,
      Net::HTTPInsufficientStorage,
      Net::HTTPLoopDetected,
      Net::HTTPRequestTimeout,
      Net::HTTPBadRequest,
      Net::HTTPNotFound
    ].freeze

    # constructor
    def setup_connection(p = {})
      @host       = p[:host] || DEFAULT_URL
      @port       = p[:port] || DEFAULT_PORT
      @version    = p[:version] || DEFAULT_VERSION
      @api_key    = p[:api_key]
    end

    def omni_get(request_url, params = {}, headers = {})
      uri = URI(request_url)
      uri.port = port
      uri.query = URI.encode_www_form(params)
      req = Net::HTTP::Get.new(uri)
      headers.each do |header, val|
        req[header] = val
      end

      make_request(req)
    end

    def omni_post(request_url, params = {}, headers = {})
      uri = URI(request_url)
      uri.port = port
      req = Net::HTTP::Post.new(uri)
      req.set_form_data(params)
      headers.each do |header, val|
        req[header] = val
      end

      make_request(req)
    end

    # headers
    def headers
      {
        'Authorization' => "Bearer #{@api_key}"
      }
    end

    def base_url
      components = { host: host, port: port }
      URI::HTTPS.build(components).to_s
    end

    # TEST connection
    def test_connection
      request_url = base_url + test_connection_path
      response = omni_get(request_url, {}, headers)
      response
    end

    # Paths
    def test_connection_path
      "/#{version}/test_connection"
    end

    private

    def retry_on_server_error(&block)
      @retry_index = 0
      begin
        yield block
      rescue *EXCEPTIONS_INCLUDING_MESSAGES => e
        raise RetriesLimitReached, e.message if retries_limit_reached?

        sleep(RETRIES_DELAYS_ARRAY[@retry_index])
        @retry_index += 1
        retry
      rescue *EXCEPTIONS_EXCLUDING_MESSAGES => e
        if retries_limit_reached?
          message = "#{e&.data&.code} #{e&.data&.code_type}"
          raise RetriesLimitReached, message
        end

        sleep(RETRIES_DELAYS_ARRAY[@retry_index])
        @retry_index += 1
        retry
      rescue Net::HTTPClientException => e
        raise Net::HTTPClientException.new(e.message.tr('"', ''), e.response)
      end
    end

    def make_request(request)
      retry_on_server_error do
        uri = request.uri
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end
        res.error! if !res.is_a?(Net::HTTPSuccess) && CLIENT_ERRORS.include?(res.code_type)

        res
      end
    end

    def retries_limit_reached?
      @retry_index >= MAX_RETRIES_COUNT
    end
  end
end
