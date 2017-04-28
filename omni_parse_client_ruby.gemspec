Gem::Specification.new do |s|
  s.name        = 'omni_parse_client_ruby'
  s.version     = '0.0.0'
  s.date        = '2017-04-27'
  s.summary     = 'Client for omniparse API'
  s.description = 'Client for omniparse API'
  s.authors     = ['Brian Long', 'Michał Marzec']
  s.email       = 'brian.long@firstmoversadvantage.com'
  s.files       = ['lib/omni_parse_client_ruby.rb',
                   'lib/omni_parse_client_ruby/base.rb',
                   'lib/omni_parse_client_ruby/loggable.rb',
                   'lib/omni_parse_client_ruby/connection.rb',
                   'lib/omni_parse_client_ruby/parsers/html_parser.rb']
  s.homepage    =
    'http://www.firstmoversadvantage.com/'
  s.license     = 'MIT'
  s.add_runtime_dependency 'rest-client', '~> 2.0.2', '>= 2.0.2'
end
