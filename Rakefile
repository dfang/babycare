# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# fix travis Don't know how to build task 'default' error
# require 'rspec/core/rake_task'
# task default: :spec
# RSpec::Core::RakeTask.new

# or simply
task default: :spec
