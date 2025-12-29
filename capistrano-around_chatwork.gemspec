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

  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  %w(img/).each do |exclude_dir|
    spec.files.reject! { |filename| filename.start_with?(exclude_dir) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", ">= 3.0.0"
  spec.add_dependency "chatwork"

  spec.add_development_dependency "bcrypt_pbkdf"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "ed25519"
  spec.add_development_dependency "rake"
end
