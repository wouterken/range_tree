# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'range_tree/version'

Gem::Specification.new do |spec|
  spec.name          = "range_tree"
  spec.version       = RangeTree::VERSION
  spec.authors       = ["Wouter Coppieters"]
  spec.email         = ["wouter.coppieters@youdo.co.nz"]
  spec.summary       = %q{An efficient tree structure for querying on data with overlapping ranges}
  spec.description   = %q{An efficient tree structure for querying on data with overlapping ranges}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
