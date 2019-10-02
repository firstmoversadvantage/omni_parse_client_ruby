require 'test_helper.rb'

class TestConnection < MiniTest::Test
  def setup
    @omni_client = Omni::Client.new(host: 'www.example.com',
                                   version: 'api/v1',
                                   api_key: '123')
    @request_url = 'www.example.com'
  end

  ERROR_CODES_MESSAGES=
    {
      '500': '500 Internal Server Error',
      '501': '501 Not Implemented',
      '502': '502 Bad Gateway',
      '503': '503 Service Unavailable',
      '504': '504 Gateway Timeout',
      '507': '507 Insufficient Storage',
      '508': '508 Loop Detected'
    }

  ERROR_CODES_MESSAGES.each do |error_code, error_message|
    define_method 'test_omni_get_server_error_' + error_code.to_s do
      stub_request(:get, @request_url).to_return(body: "abc", status: error_code.to_s.to_i)
      stub_rest_client do
        err = assert_raises OmniparseClient::Connection::RetriesLimitReached do
          @omni_client.omni_get(@request_url)
        end

        assert_equal error_message, err.message
      end
    end
  end

  ERROR_CODES_MESSAGES.each do |error_code, error_message|
    define_method 'test_omni_post_server_error_' + error_code.to_s do
      stub_request(:post, @request_url).to_return(body: "abc", status: error_code.to_s.to_i)
      stub_rest_client do
        err = assert_raises OmniparseClient::Connection::RetriesLimitReached do
          @omni_client.omni_post(@request_url)
        end

        assert_equal error_message, err.message
      end
    end
  end

  private

  def stub_rest_client(&block)
    OmniparseClient::Connection.stub_const(
      :RETRIES_DELAYS_ARRAY, [0, 0, 0, 0, 0]
    ) do
      yield block
    end
  end
end
