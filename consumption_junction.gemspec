# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "consumption_junction/version"

Gem::Specification.new do |s|
  s.name        = "consumption_junction"
  s.version     = ConsumptionJunction::VERSION
  s.authors     = ["Enable Labs"]
  s.email       = ["info@enablelabs.com"]
  s.homepage    = ""
  s.summary     = %q{A library for managing threaded AMQP consumers.}
  s.description = %q{A library for managing threaded AMQP consumers.}

  s.rubyforge_project = "consumption_junction"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'activesupport'
  s.add_dependency 'amqp'
  s.add_dependency 'celluloid', '>= 0.2.1'
  s.add_dependency 'eventmachine'
  
  s.add_development_dependency('carrot')
end
