require 'minitest/autorun'
require 'omni_parse_client_ruby'

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
  end
end
