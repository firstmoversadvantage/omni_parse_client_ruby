# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'omni_parse_client_ruby'
  s.version     = '1.4.1'
  s.date        = '2023-09-28'
  s.summary     = 'Client for omniparse API'
  s.description = 'Client for omniparse API'
  s.authors     = ['Brian Long', 'Michał Marzec', 'Paweł Jermalonek']
  s.email       = 'brian.long@firstmoversadvantage.com'
  s.files       = ['lib/omni_parse_client_ruby.rb',
                   'lib/omni_parse_client_ruby/base.rb',
                   'lib/omni_parse_client_ruby/loggable.rb',
                   'lib/omni_parse_client_ruby/connection.rb',
                   'lib/omni_parse_client_ruby/parsers/html_parser.rb']
  s.homepage    = 'https://www.fmadata.com/'
  s.license     = 'MIT'
  s.add_dependency 'net-http', '~> 0.4.1'
  s.add_development_dependency 'minitest-stub-const', '~> 0.6'
  s.add_development_dependency 'webmock', '~> 3.24'
end
