# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'woro/version'

Gem::Specification.new do |spec|
  spec.name          = "woro"
  spec.version       = Mina::Woro::VERSION
  spec.authors       = ["Daniel Senff"]
  spec.email         = ["mail@danielsenff.de"]
  spec.summary       = %q{Write once, run once. One-time migration task management on remote servers through mina.}
  spec.description   = %q{Write once, run once.}
  spec.homepage    = "http://github.com/Dahie/woro"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mina", ">= 0.2.1"
  #spec.add_dependency "gist"
  spec.add_dependency "cmdparse"
  spec.add_dependency "rugged"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "pry-byebug"
end
