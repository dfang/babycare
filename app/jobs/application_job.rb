# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # report any uncaught errors in a job to Rollbar
  include Rollbar::ActiveJob

  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
