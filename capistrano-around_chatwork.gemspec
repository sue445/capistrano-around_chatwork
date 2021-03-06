# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/around_chatwork/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-around_chatwork"
  spec.version       = Capistrano::AroundChatwork::VERSION
  spec.authors       = ["sue445"]
  spec.email         = ["sue445@sue445.net"]

  spec.summary       = %q{post to ChatWork before and after the specified task}
  spec.description   = %q{post to ChatWork before and after the specified task}
  spec.homepage      = "https://github.com/sue445/capistrano-around_chatwork"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.1.0"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  %w(img/).each do |exclude_dir|
    spec.files.reject! { |filename| filename.start_with?(exclude_dir) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", ">= 3.0.0"
  spec.add_dependency "cha", ">= 1.2.0"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake"
end
