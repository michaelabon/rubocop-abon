# frozen_string_literal: true

require "pathname"

require_relative "rubocop/abon/version"

module RuboCop
  module Abon
    CONFIG_DEFAULT = Pathname.new(__dir__).parent.join("config", "default.yml").freeze
  end
end
