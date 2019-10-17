# frozen_string_literal: true

require 'test_helper.rb'
# :nodoc:
class OmniClientTest < Minitest::Test
  def test_initialize_omni_client
    Omni::Client.new(host: 'www.example.com',
                     version: 'api/v1',
                     api_key: '123')
  end

  def test_has_html_parser_client
    client = Omni::Client.new(host: 'www.example.com',
                              version: 'api/v1',
                              api_key: '123')

    assert client.html.is_a?(OmniparseClient::Parsers::HtmlParser)
    assert client.fixture.is_a?(OmniparseClient::Parsers::OmniFixture)
  end
end
