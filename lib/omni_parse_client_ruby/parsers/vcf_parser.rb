# frozen_string_literal: true

module OmniparseClient
  module Parsers
    # PARSER
    # @omni = Omni::Client.new(url:     'www.example.com',
    #                          version: 'v1',
    #                          api_key: 'token')
    # @omni_vcf = @omni.vcf
    class VcfParser
      attr_reader :body, :omni_parser_id

      include Connection
      include Loggable

      def initialize(p = {})
        setup_connection(p)
      end

      # fetching all parsers
      # @omni_vcf.all(parser_id)
      def all
        self.last_request = base_url + index_path
        response = omni_get(last_request, headers)
        self.last_response = Response.new(response)
        last_response
      end

      # preparing / building vcf params
      # @omni_vcf.prepare(parser_id, body)
      def prepare(p = {})
        @body           = p[:body]
        @omni_parser_id = p[:omni_parser_id]
        true
      end

      # Post parse run
      # @omni_vcf.parse(parser_id, body)
      def parse(p = {})
        return false unless p[:body]
        return false unless p[:omni_parser_id]
        prepare(p)

        self.last_request = base_url + parse_path
        response = omni_post(last_request,
                                   params,
                                   headers)
        self.last_response = Response.new(response)
        last_response
      end

      # Post trial run
      # @omni_vcf.parse(parser_id, body)
      def trial_run(p = {})
        return false unless p[:omni_parser_id]
        prepare(p)

        self.last_request = base_url + trial_run_path
        response = omni_post(last_request,
                                   params,
                                   headers)
        self.last_response = Response.new(response)
        last_response
      end

      # parsing params
      def params
        {
          omni_parser_id: @omni_parser_id,
          body: @body
        }
      end

      # Paths
      def parse_path
        "/#{version}/vcf_parser/parse"
      end

      def trial_run_path
        "/#{version}/vcf_parser/trial_run"
      end

      def index_path
        "/#{version}/vcf_parsers"
      end
    end
  end
end
