module OmniparseClient
  # Response wrapper
  class Response
    require 'json'

    attr_reader :resp, :json, :code, :headers

    def initialize(rest_client_response)
      @resp     = rest_client_response
      @json     = JSON.parse(@resp.body)
      @code     = @resp.code
      @headers  = @resp.headers
    end
  end
end
