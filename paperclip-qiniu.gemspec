# -*- encoding: utf-8 -*-
require File.expand_path('../lib/paperclip-qiniu/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["gyzclw"]
  gem.email         = ["gyzclw@hotmail.com"]
  gem.description   = %q{new paperclip plugin for qiniu}
  gem.summary       = %q{new paperclip plugin for qiniu}
  gem.homepage      = "https://github.com/gyzclw/new_paperclip-qiniu"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "paperclip-new-qiniu"
  gem.require_paths = ["lib"]
  gem.version       = Paperclip::Qiniu::VERSION
  gem.add_dependency "paperclip",'~> 5.0', '>= 5.0.0'
  gem.add_dependency 'qiniu', '~> 6.9.0', '>= 6.9.0'
  gem.add_development_dependency 'rspec'
end
