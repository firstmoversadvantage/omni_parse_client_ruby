# frozen_string_literal: true

require 'rubygems'
require_relative 'omni_parse_client_ruby/loggable'
require_relative 'omni_parse_client_ruby/connection'
require_relative 'omni_parse_client_ruby/base'
require_relative 'omni_parse_client_ruby/response'
require_relative 'omni_parse_client_ruby/parsers/html_parser'

# Wrapper class
# Example:
# @omi = Omni::Client.new(url:     'www.example.com',
#                         version: 'v1',
#                         api_key: 'token')
module Omni
  class Client < OmniparseClient::Base; end
end
