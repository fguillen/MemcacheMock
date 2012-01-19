# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "memcache_mock/version"

Gem::Specification.new do |s|
  s.name        = "memcache_mock"
  s.version     = MemcacheMock::VERSION
  s.authors     = ["Fernando Guillen"]
  s.email       = ["fguillen.mail@gmail.com"]
  s.homepage    = ""
  s.summary     = "Simple key/value mocked storage system"
  s.description = "Simple key/value mocked storage system"

  s.rubyforge_project = "memcache_mock"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler",   "1.0.21"
  s.add_development_dependency "rake",      "0.9.2.2"
  s.add_development_dependency "mocha",     "0.10.0"
end
