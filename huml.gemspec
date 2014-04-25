# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + "/lib/huml/version"
require "date"

Gem::Specification.new do |s|
  s.name          = 'huml'
  s.version       = Huml::VERSION
  s.date          = Date.today.to_s

  s.authors       = ['shelling']
  s.email         = ['navyblueshellingford@gmail.com']
  s.homepage      = 'https://github.com/shelling/huml'
  s.summary       = 'Huml'

  s.require_paths = ['lib']
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.license       = 'MIT'
end
