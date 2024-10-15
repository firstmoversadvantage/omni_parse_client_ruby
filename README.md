# Omni Parse Client for Ruby

This gem is a client library for [www.omniparse.com](https://www.omniparse.com) API

# Usage

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'omni_parse_client_ruby', '1.3.0', git: 'https://github.com/firstmoversadvantage/omni_parse_client_ruby.git'
```

Sign up at [www.omniparse.com](https://www.omniparse.com)  and set up your account.

Create your own OmniParser.

From your application set up connection:

```ruby
 @omni = Omni::Client.new(host: 'localhost', version: '/api/v1', api_key: 'key', port: 3000)
```

## Configuration of requests' retries

Gem retries connection on ServerErrors, SocketError and Timeouts. Default configuration is hardcoded in the module Connection.
It goes as follows: 
```ruby
MAX_RETRIES_COUNT=5
RETRIES_DELAYS_ARRAY=[5, 30, 2*60, 10*60, 30*60]
```
- **MAX_RETRIES_COUNT** describes retry attempts count.
- **RETRIES_DELAYS_ARRAY** describes consequent deplay times of each retry in seconds.

**To override these settings use environment variables:**

`OMNI_MAX_RETRIES_COUNT` and `OMNI_RETRIES_DELAYS_ARRAY`

- **OMNI_MAX_RETRIES_COUNT** should be an integer.
- **OMNI_RETRIES_DELAYS_ARRAY** should be a string of integers, separeted by `,`. Each integer relates to consequent delay time in seconds. Array length should not be lower than `MAX_RETRIES_COUNT`.

Example for .env file:
```ruby
OMNI_MAX_RETRIES_COUNT=5
OMNI_RETRIES_DELAYS_ARRAY=1,5,10,15,25
```

## HTML parsing

Set up HTML client

**html** - html body you would like to parse

**omni_parser_id** - id of OmniParser 

```ruby
@omni_html_client = @omni.html
@omni_client.parse(html: html, omni_parser_id: omni_parser_id)
```

## Fixture

Set up OmniFixture client

**omni_parser_id** - id of OmniParser 

#all - Get all parser fixtures
```ruby
@omni_fixture = @omni.fixture
@omni_fixture.all(omni_parser_id)
```

## Testing
Install all required gems (which are listed in .gemspec file) and run `rake test` in order to run tests.

## Contributing
Contact: [fmadata.com](https://www.fmadata.com)

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
