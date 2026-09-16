# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "rake", require: false

# Source of the vendored baseline. Pinned: 3.x drops the formatting cops we want.
# Needed only to regenerate config/shopify_baseline.yml, never at runtime.
gem "rubocop-shopify", "= 2.18.0", require: false

# Optional companions, so `rake rubocop` can dogfood every opt-in config.
gem "rubocop-minitest", require: false
gem "rubocop-performance", require: false
gem "rubocop-rake", require: false
gem "rubocop-rspec", require: false
