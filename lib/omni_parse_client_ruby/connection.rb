# frozen_string_literal: true

module OmniparseClient
  # Connection module
  module Connection
    require 'uri'

    attr_reader :api_key, :port, :version, :host

    DEFAULT_URL     = 'www.example.com'.freeze
    DEFAULT_PORT    = 80
    DEFAULT_VERSION = '/api/v1'.freeze

    # constructor
    def setup_connection(p = {})
      @host       = p[:host] || DEFAULT_URL
      @port       = p[:port] || DEFAULT_PORT
      @version    = p[:version] || DEFAULT_VERSION
      @api_key    = p[:api_key]
    end

    # headers
    def headers
      {
        'Authorization' => "Bearer #{@api_key}"
      }
    end

    def base_url
      components = { host: host, port: port }
      URI::HTTP.build(components).to_s
    end

    # TEST connection
    def test_connection
      request_url = base_url + test_connection_path
      response = RestClient.get(request_url, headers)
      response
    end

    # Paths
    def test_connection_path
      "/#{version}/test_connection"
    end
  end
end
