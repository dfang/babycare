# frozen_string_literal: true

# https://rollbar.com/docs/notifier/rollbar-gem/

require 'rollbar'

Rollbar.configure do |config|
  if Rails.env.development?
    config.enabled = false
  else
    config.enabled = true
    config.use_sidekiq  'queue' => 'default'
    config.access_token = Settings.rollbar.access_token
  end
end
