# frozen_string_literal: true

require 'test_helper.rb'
# :nodoc:
class HtmlParserTest < Minitest::Test
  def setup
    omni_client = Omni::Client.new(host: 'www.example.com',
                                   version: 'api/v1',
                                   api_key: '123')
    @html_parser = omni_client.html
    @html_parser_params = {
      omni_parser_id: 1,
      html: '<html><body><div class="price">$1,234</div></body></html>'
    }
  end

  def test_has_headers
    assert @html_parser.headers.is_a?(Hash)
  end

  def test_has_params
    assert @html_parser.prepare(@html_parser_params)
    assert @html_parser.params.is_a?(Hash)
  end

  def test_parse
    url = 'https://www.example.com/api/v1/html_parser/parse'
    stub_request(:post, url).with(
      body: @html_parser_params
    ).to_return(
      status: 200,
      body: "{\"omni_parser_id\":1,\"omni_configs_ids\":[1],\"parser_type\":\"html\",\"values\":{\"asking_price\":[\"\$1,234\"]}}"
    )

    @html_parser.parse(@html_parser_params)
  end

  def test_blank_html
    url = 'https://www.example.com/api/v1/html_parser/parse'
    stub_request(:post, url).with(
      body: { omni_parser_id: 1, html: '' }
    ).to_return(status: 400, body: "{\"errors\":[\"Html not present\"]}")

    @html_parser.parse({ omni_parser_id: 1, html: '' })
  end
end
