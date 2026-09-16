# frozen_string_literal: true

require "rubocop/rake_task"

Dir["tasks/*.rake"].each { |f| load(f) }

RuboCop::RakeTask.new

task(default: :rubocop)
