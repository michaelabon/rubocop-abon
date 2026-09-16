# frozen_string_literal: true

require_relative "lib/rubocop/abon/version"

Gem::Specification.new do |spec|
  spec.name = "rubocop-abon"
  spec.version = RuboCop::Abon::VERSION
  spec.authors = ["Michael Abon"]

  spec.summary = "Michael Abon's shared RuboCop configuration."
  spec.description = "Ejecting before rubocop-shopify 3.x"
  spec.homepage = "https://github.com/michaelabon/rubocop-abon"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 4.0"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir["config/**/*.yml", "lib/**/*.rb", "LICENSE.md", "README.md"]
  spec.require_paths = ["lib"]

  # Only a floor. The vendored baseline is plain YAML with no ERB, so it does not
  # break the way rubocop-shopify 2.18 does when RuboCop moves underneath it.
  spec.add_dependency("rubocop", ">= 1.72")
end
