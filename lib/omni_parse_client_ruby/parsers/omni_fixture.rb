# frozen_string_literal: true

module OmniparseClient
  module Parsers
    # CONFIG
    # @omni = Omni::Client.new(url:     'www.example.com',
    #                          version: 'v1',
    #                          api_key: 'token')
    # @omni_fixture = @omni.fixture
    #
    class OmniFixture
      include Connection
      include Loggable

      def initialize(p = {})
        setup_connection(p)
      end

      # fetching all parsers
      # @omni_fixture.all(parser_id)
      def all(parser_id)
        self.last_request = base_url + index_path
        response = omni_get(last_request, params(parser_id), headers)
        self.last_response = Response.new(response)
        last_response
      end

      def params(parser_id)
        {
          omni_parser_id: parser_id
        }
      end

      # Paths
      def index_path
        "/#{version}/omni_fixtures"
      end
    end
  end
end
