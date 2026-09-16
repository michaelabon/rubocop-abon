# frozen_string_literal: true

require "erb"
require "yaml"

namespace :vendor do
  desc "Regenerate config/shopify_baseline.yml from the pinned rubocop-shopify"
  task :shopify do
    require "rubocop"

    spec = Gem.loaded_specs.fetch("rubocop-shopify")
    source = File.join(spec.full_gem_path, "rubocop.yml")

    config = YAML.safe_load(ERB.new(File.read(source)).result(binding), aliases: true)
    # rubocop-abon supplies its own AllCops and inherit_mode in default.yml.
    config.delete("AllCops")
    config.delete("inherit_mode")

    # Shopify 2.18 is frozen, so it still names cops that RuboCop has since removed
    # (Style/DoubleCopDisableDirective, and more as RuboCop keeps moving). Left in,
    # each one makes every `rubocop` run print an obsolete-configuration warning.
    registry = RuboCop::Cop::Registry.global
    dropped = config.keys.reject { |name| registry.find_by_cop_name(name) }
    dropped.each { |name| config.delete(name) }
    puts("Dropped #{dropped.size} cop(s) unknown to RuboCop #{RuboCop::Version::STRING}: " \
      "#{dropped.join(", ")}") unless dropped.empty?

    header = <<~HEADER
      # ---------------------------------------------------------------------------
      # VENDORED — do not hand-edit. Regenerate with `rake vendor:shopify`.
      #
      # The Shopify Ruby Style Guide ruleset as shipped in rubocop-shopify
      # #{spec.version}, ERB rendered out and AllCops/inherit_mode framing removed.
      #
      # MIT License. Copyright (c) 2015-2022 Shopify Inc.
      # https://github.com/Shopify/ruby-style-guide
      #
      # Vendored because rubocop-shopify 3.x disables the formatting cops this
      # style rests on. Put personal opinions in default.yml, not here.
      # ---------------------------------------------------------------------------
    HEADER

    out = File.expand_path("../config/shopify_baseline.yml", __dir__)
    File.write(out, header + config.to_yaml.delete_prefix("---\n"))
    puts "Wrote #{config.keys.size} cop entries to #{out}"
  end
end
