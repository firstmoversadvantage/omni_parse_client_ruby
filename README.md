# Omni Parse Client for Ruby

This gem is a client library for [www.omniparse.com](www.omniparse.com) API

# Usage

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'omni_parse_client_ruby', git: 'git://github.com/firstmoversadvantage/omni_parse_client_ruby.git',
                              branch: 'initialize_client'
```

Sign up at [www.omniparse.com](www.omniparse.com)  and set up your account.

Create your own OmniParser.

From your application set up connection:

```ruby
 @omni = Omni::Client.new(host: 'localhost', version: '/api/v1', api_key: 'key', port: 3000)
```

## HTML parsing

Set up HTML client

**html** - html body you would like to parse

**omni_parser_id** - id of OmniParser 

```ruby
@omni_html_client = @omni.html
@omni_client.parse(html: html, omni_parser_id: omni_parser_id)
```


## Contributing
Contact: http://www.firstmoversadvantage.com

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).