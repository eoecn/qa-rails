Gem::Specification.new do |s|
  s.name        = 'qa-rails'
  s.version     = '0.1.2'
  s.date        = '2013-07-17'
  s.summary     = File.read("README.markdown").split(/===+/)[1].strip.split("\n")[0]
  s.description = s.summary
  s.authors     = ["David Chen"]
  s.email       = 'mvjome@gmail.com'
  s.homepage    = 'http://github.com/eoecn/qa-rails'
  s.license     = 'MIT'

  s.add_dependency "rails"
  s.add_dependency "haml"
  s.add_dependency "kaminari"
  s.add_dependency "cells", ">= 3.8.2"
  s.add_dependency "markdown-ruby-china"
  s.add_dependency 'facebox-rails'
  s.add_dependency 'acts_as_paranoid_boolean_column'

  s.files = `git ls-files`.split("\n")
end
