# frozen_string_literal: true

module OmniparseClient
  # Log responses and requests methods
  module Loggable
    attr_accessor :last_request, :last_response
  end
end
