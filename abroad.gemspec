$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'abroad/version'

Gem::Specification.new do |s|
  s.name     = 'abroad'
  s.version  = ::Abroad::VERSION
  s.authors  = ['Cameron Dutro']
  s.email    = ['camertron@gmail.com']
  s.homepage = "https://github.com/camertron/abroad"

  s.description = s.summary = 'A set of parsers and serializers for dealing with localization file formats.'

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.add_dependency 'htmlentities', '~> 4.0'
  s.add_dependency 'json-stream', '~> 0.0'
  s.add_dependency 'json-write-stream', '~> 1.0'
  s.add_dependency 'nokogiri', '~> 1.0'
  s.add_dependency 'xml-write-stream', '~> 1.0'
  s.add_dependency 'yaml-write-stream', '~> 1.0'

  s.require_path = 'lib'
  s.files = Dir['{lib,spec}/**/*', 'README.md', 'abroad.gemspec']
end
