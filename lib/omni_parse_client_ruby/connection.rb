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
      Net::HTTPGatewayTimeout,
      Net::HTTPRequestTimeout
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
      uri.query = URI.encode_www_form(params)
      headers.each do |header, val|
        uri[header] = val
      end

      retry_on_server_error do
        res = Net::HTTP.get_response(uri)
        res.error! if !res.is_a?(Net::HTTPSuccess) && CLIENT_ERRORS.include?(res.code_type)

        res
      end
    end

    def omni_post(request_url, params = {}, headers = {})
      uri = URI(request_url)
      headers.each do |header, val|
        uri[header] = val
      end

      retry_on_server_error do
        res = Net::HTTP.post_form(uri, params)
        res.error! if !res.is_a?(Net::HTTPSuccess) && CLIENT_ERRORS.include?(res.code_type)

        res
      end
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
        message = "#{e&.data&.code} #{e&.data&.code_type}"
        raise RetriesLimitReached, message if retries_limit_reached?

        sleep(RETRIES_DELAYS_ARRAY[@retry_index])
        @retry_index += 1
        retry
      end
    end

    def retries_limit_reached?
      @retry_index >= MAX_RETRIES_COUNT
    end
  end
end
