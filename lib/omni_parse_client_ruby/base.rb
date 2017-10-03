# frozen_string_literal: true

module OmniparseClient
  # Main Class for the library
  # here all modules are beeing included into class
  class Base
    attr_reader :html, :fixture

    include Connection

    def initialize(p = {})
      setup_connection(p)
      @html    = Parsers::HtmlParser.new(p)
      @fixture = Parsers::OmniFixture.new(p)
    end
  end
end
