# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quad_tree/version'

Gem::Specification.new do |gem|
  gem.name          = "quad_tree"
  gem.version       = QuadTree::VERSION
  gem.authors       = ["Andrew Ledvina"]
  gem.email         = ["wvvwwvw@gmail.com"]
  gem.description   = %q{A QuadTree}
  gem.summary       = %q{Just a quad tree}
  gem.homepage      = "https://github.com/rokob/quad_tree"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", "~> 1.5"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency 'simplecov', "~> 0.7.1"
end
