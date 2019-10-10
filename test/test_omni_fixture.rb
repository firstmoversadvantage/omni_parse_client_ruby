require 'test_helper.rb'
# :nodoc:
class OmniFixtureTest < Minitest::Test
  def setup
    omni_client = Omni::Client.new(host: 'www.example.com',
                                   version: 'api/v1',
                                   api_key: '123')
    @html_fixture = omni_client.fixture
    @html_parser_params = { omni_parser_id: 1 }
  end

  def test_has_headers
    assert @html_fixture.headers.is_a?(Hash)
  end

  def test_has_params
    assert @html_fixture.respond_to?(:index_path)
  end
end
