# frozen_string_literal: true

module OmniparseClient
  # Response wrapper
  class Response
    require 'json'

    attr_reader :resp, :json, :code, :headers

    def initialize(client_response)
      @resp     = client_response
      @json     = JSON.parse(@resp.body)
      @code     = @resp.code.to_i
      @headers  = @resp.to_hash
    end
  end
end
