# frozen_string_literal: true

require 'rest-client'

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
    RETRY_ON_ERRORS = [
      RestClient::InternalServerError,
      RestClient::NotImplemented,
      RestClient::BadGateway,
      RestClient::ServiceUnavailable,
      RestClient::GatewayTimeout,
      RestClient::InsufficientStorage,
      RestClient::LoopDetected,
      SocketError,
      RestClient::Exceptions::OpenTimeout
    ].freeze

    # constructor
    def setup_connection(p = {})
      @host       = p[:host] || DEFAULT_URL
      @port       = p[:port] || DEFAULT_PORT
      @version    = p[:version] || DEFAULT_VERSION
      @api_key    = p[:api_key]
    end

    def omni_get(request_url, params = {})
      retry_on_server_error { RestClient.get(request_url, params) }
    end

    def omni_post(request, params = {}, headers = {})
      retry_on_server_error { RestClient.post(request, params, headers) }
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
      response = omni_get(request_url, headers)
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
      rescue *RETRY_ON_ERRORS => e
        raise RetriesLimitReached, e.message if retries_limit_reached?

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
