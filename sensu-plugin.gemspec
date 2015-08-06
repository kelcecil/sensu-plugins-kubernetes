require File.expand_path(File.dirname(__FILE__)) + '/lib/sensu-plugin'

Gem::Specification.new do |s|
  s.name          = 'sensu-plugins-kubernetes'
  s.version       = Sensu::Plugin::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Kel Cecil']
  s.email         = ['kelcecil@praisechaos.com']
  s.homepage      = 'https://github.com/kelcecil/sensu-plugins-kubernetes'
  s.summary       = 'Sensu Plugin for Kubernetes'
  s.description   = 'Sensu plugin for ensuring your Kubernetes setup is a-okay!'
  s.license       = 'MIT'
  s.has_rdoc      = false
  s.require_paths = ['lib']
  s.files         = Dir['{bin,lib}/**/*.rb']
  s.test_files    = Dir['test/*.rb']

  s.add_dependency('json')
  s.add_dependency('mixlib-cli', '>= 1.1.0')
  s.add_dependency('kubeclient', '0.3.0')

  s.add_development_dependency('rake')
  s.add_development_dependency('minitest')
end
