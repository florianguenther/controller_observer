# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "controller_observer/version"

Gem::Specification.new do |s|
  s.name        = "controller_observer"
  s.version     = ControllerObserver::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Florian Günther"]
  s.email       = ["mail@gee-f.de"]
  s.homepage    = ""
  s.summary     = %q{Observe your ActionControllers in rails}
  s.description = %q{Observers for ActionController similar to ActiveRecord Observers}

  # s.rubyforge_project = "controller_observer"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
