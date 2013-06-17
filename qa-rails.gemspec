Gem::Specification.new do |s|
  s.name        = 'qa-rails'
  s.version     = '0.1'
  s.date        = '2013-04-08'
  s.summary     = File.read("README.markdown").split(/===+/)[0].strip
  s.description = s.summary
  s.authors     = ["David Chen"]
  s.email       = 'mvjome@gmail.com'
  s.homepage    = 'http://rubygems.org/gems/qa-rails'

  s.add_dependency "rails"
  s.add_dependency "haml"
  s.add_dependency "kaminari"
  s.add_dependency "cells", ">= 3.8.2"
  s.add_dependency "markdown-ruby-china"
  s.add_dependency 'facebox-rails'

  s.files = `git ls-files`.split("\n")
end
