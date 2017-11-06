require 'minitest/autorun'
require 'omni_parse_client_ruby'

# :nodoc:
class VcfParserTest < Minitest::Test
  def setup
    omni_client = Omni::Client.new(host: 'www.example.com',
                                   version: 'api/v1',
                                   api_key: '123')
    @vcf_parser = omni_client.vcf
    @vcf_parser_params = { omni_parser_id: 1, body: '<body></body>' }
  end

  def test_has_headers
    assert @vcf_parser.headers.is_a?(Hash)
  end

  def test_has_params
    assert @vcf_parser.prepare(@vcf_parser_params)
    assert @vcf_parser.params.is_a?(Hash)
  end
end