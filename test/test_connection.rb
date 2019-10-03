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
    [:get, :post].each do |method|
      define_method "test_omni_#{method}_server_error_#{error_code}" do
        stub_request(method, @request_url).to_return(body: "abc", status: error_code.to_s.to_i)
        stub_rest_client do
          err = assert_raises OmniparseClient::Connection::RetriesLimitReached do
            @omni_client.send("omni_#{method}", @request_url)
          end

          assert_equal error_message, err.message
        end
      end
    end
  end

  [:get, :post].each do |method|
    define_method "test_omni_#{method}_socketerror" do
      stub_request(method, @request_url).to_raise(SocketError)
      stub_rest_client do
        err = assert_raises OmniparseClient::Connection::RetriesLimitReached do
          @omni_client.send("omni_#{method}",@request_url)
        end
        assert_equal "Exception from WebMock", err.message
      end
    end
  end

  [:get, :post].each do |method|
    define_method "test_omni_#{method}_timeout" do
      stub_request(method, @request_url).to_timeout
      stub_rest_client do
        err = assert_raises OmniparseClient::Connection::RetriesLimitReached do
          @omni_client.send("omni_#{method}",@request_url)
        end
        assert_equal "Timed out connecting to server", err.message
      end
    end
  end

  [:get, :post].each do |method|
    define_method "test_omni_#{method}_standarderror" do
      stub_request(method, @request_url).to_raise(StandardError)
      stub_rest_client do
        err = assert_raises StandardError do
          @omni_client.send("omni_#{method}",@request_url)
        end
        assert_equal "Exception from WebMock", err.message
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
