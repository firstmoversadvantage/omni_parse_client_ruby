# frozen_string_literal: true

require 'test_helper.rb'

class TestConnection < MiniTest::Test
  def setup
    @omni_client = Omni::Client.new(host: 'www.example.com',
                                    version: 'api/v1',
                                    api_key: '123')
    @request_url = 'http://www.example.com'
  end

  ERROR_CODES_MESSAGES =
    {
      '500': '500 Net::HTTPInternalServerError',
      '501': '501 Net::HTTPNotImplemented',
      '502': '502 Net::HTTPBadGateway',
      '503': '503 Net::HTTPServiceUnavailable',
      '504': '504 Net::HTTPGatewayTimeout',
      '507': '507 Net::HTTPInsufficientStorage',
      '508': '508 Net::HTTPLoopDetected'
    }.freeze

  ERROR_CODES_MESSAGES.each do |error_code, error_message|
    %i[get post].each do |method|
      define_method "test_omni_#{method}_server_error_#{error_code}" do
        code = error_code.to_s.to_i
        stub_request(method, @request_url).to_return(body: 'abc', status: code)
        stub_client_retry_delays do
          err =
            assert_raises OmniparseClient::Connection::RetriesLimitReached do
              @omni_client.send("omni_#{method}", @request_url)
            end

          assert_equal error_message, err.message
        end
      end
    end
  end

  %i[get post].each do |method|
    define_method "test_omni_#{method}_socketerror" do
      stub_request(method, @request_url).to_raise(SocketError)
      stub_client_retry_delays do
        err = assert_raises OmniparseClient::Connection::RetriesLimitReached do
          @omni_client.send("omni_#{method}", @request_url)
        end
        assert_equal 'Exception from WebMock', err.message
      end
    end
  end

  %i[get post].each do |method|
    define_method "test_omni_#{method}_timeout" do
      stub_request(method, @request_url).to_timeout
      stub_client_retry_delays do
        err = assert_raises OmniparseClient::Connection::RetriesLimitReached do
          @omni_client.send("omni_#{method}", @request_url)
        end
        assert_equal 'execution expired', err.message
      end
    end
  end

  %i[get post].each do |method|
    define_method "test_omni_#{method}_standarderror" do
      stub_request(method, @request_url).to_raise(StandardError)
      stub_client_retry_delays do
        err = assert_raises StandardError do
          @omni_client.send("omni_#{method}", @request_url)
        end
        assert_equal 'Exception from WebMock', err.message
      end
    end
  end

  private

  def stub_client_retry_delays(&block)
    OmniparseClient::Connection.stub_const(
      :RETRIES_DELAYS_ARRAY, [0, 0, 0, 0, 0]
    ) do
      yield block
    end
  end
end
