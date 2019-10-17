# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'omni_parse_client_ruby'
  s.version     = '1.2.0'
  s.date        = '2019-10-17'
  s.summary     = 'Client for omniparse API'
  s.description = 'Client for omniparse API'
  s.authors     = ['Brian Long', 'Michał Marzec', 'Paweł Jermalonek']
  s.email       = 'brian.long@firstmoversadvantage.com'
  s.files       = ['lib/omni_parse_client_ruby.rb',
                   'lib/omni_parse_client_ruby/base.rb',
                   'lib/omni_parse_client_ruby/loggable.rb',
                   'lib/omni_parse_client_ruby/connection.rb',
                   'lib/omni_parse_client_ruby/parsers/html_parser.rb']
  s.homepage    = 'http://www.fmadata.com/'
  s.license     = 'MIT'
  s.add_dependency 'rest-client', '~> 2.0.2', '>= 2.0.2'
  s.add_development_dependency 'minitest-stub-const'
  s.add_development_dependency 'webmock'
end
