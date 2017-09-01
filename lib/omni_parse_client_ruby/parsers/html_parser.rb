# frozen_string_literal: true

module OmniparseClient
  module Parsers
    # PARSER
    # @omni = Omni::Client.new(url:     'www.example.com',
    #                          version: 'v1',
    #                          api_key: 'token')
    # @omni_html = @omni.html
    class HtmlParser
      attr_reader :html, :omni_parser_id

      include Connection
      include Loggable

      def initialize(p = {})
        setup_connection(p)
      end

      # fetching all parsers
      # @omni_html.all(parser_id)
      def all
        self.last_request = base_url + index_path
        response = RestClient.get(last_request, headers)
        self.last_response = Response.new(response)
        last_response
      end

      # preparing / building html params
      # @omni_html.prepare(parser_id, html)
      def prepare(p = {})
        @html           = p[:html]
        @omni_parser_id = p[:omni_parser_id]
        true
      end

      # Post parse run
      # @omni_html.parse(parser_id, html)
      def parse(p = {})
        return false unless p[:html]
        return false unless p[:omni_parser_id]
        prepare(p)

        self.last_request = base_url + parse_path
        response = RestClient.post(last_request,
                                   params,
                                   headers)
        self.last_response = Response.new(response)
        last_response
      end

      # Post trial run
      # @omni_html.parse(parser_id, html)
      def trial_run(p = {})
        return false unless p[:omni_parser_id]
        prepare(p)

        self.last_request = base_url + trial_run_path
        response = RestClient.post(last_request,
                                   params,
                                   headers)
        self.last_response = Response.new(response)
        last_response
      end

      # parsing params
      def params
        {
          omni_parser_id: @omni_parser_id,
          html: @html
        }
      end

      # Paths
      def parse_path
        "/#{version}/html_parser/parse"
      end

      def trial_run_path
        "/#{version}/html_parser/trial_run"
      end

      def index_path
        "/#{version}/html_parsers"
      end
      #
    end
  end
end
