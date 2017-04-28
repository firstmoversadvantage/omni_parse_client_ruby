require 'minitest/autorun'
require 'omni_parse_client_ruby'

# :nodoc:
class HtmlParserTest < Minitest::Test
  def setup
    omni_client = Omni::Client.new(host: 'www.example.com',
                                   version: 'api/v1',
                                   api_key: '123')
    @html_parser = omni_client.html
    @html_parser_params = { omni_parser_id: 1, html: '<body></body>' }
  end

  def test_has_headers
    assert @html_parser.headers.is_a?(Hash)
  end

  def test_has_params
    assert @html_parser.prepare(@html_parser_params)
    assert @html_parser.params.is_a?(Hash)
  end
end
