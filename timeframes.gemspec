# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "timeframes/version"

Gem::Specification.new do |s|
  s.name        = "timeframes"
  s.version     = Timeframes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrew Nordman"]
  s.email       = ["cadwallion@gmail.com"]
  s.homepage    = "http://github.com/cadwallion/timeframes"
  s.summary     = %q{Manage timeframes easily}
  s.description = %q{Manage start-stop timeframes and a series of timeframes for pattern matching and iterating.}


  s.add_dependency = "activesupport"
  s.add_development_dependency = "rspec"
  
  s.rubyforge_project = "timeframes"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
