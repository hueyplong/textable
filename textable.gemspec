# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'textable/version'

Gem::Specification.new do |gem|
  gem.name          = "textable"
  gem.version       = Textable::VERSION
  gem.authors       = ["Kirk Brown"]
  gem.email         = ["kirk@dostuffmedia.com"]
  gem.description   = <<-EOF
                        Rails utility for keeping TEXT fields out of your Model tables and in their
                        own little world. Useful for MySQL table optimization if you have models
                        that need TEXT fields and don't want to clutter your schema with them. Variable
                        length fields like TEXT and BLOB will force MySQL to sort on disk, so moving
                        those fields to their own table makes for nicer performance.
                      EOF
  gem.summary       = %q{Rails utility for linking TEXT fields to models}
  gem.homepage      = "http://github.com/hueyplong/textable"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
