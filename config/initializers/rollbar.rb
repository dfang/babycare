# frozen_string_literal: true

require 'rollbar'

Rollbar.configure do |config|
  if Rails.env.production?
    config.enabled = true
    config.access_token = Settings.rollbar.access_token
  else
    config.enabled = false
  end
end

