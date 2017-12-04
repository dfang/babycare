# frozen_string_literal: true

require 'rollbar'

Rollbar.configure do |config|
  config.access_token = Settings.rollbar.access_token
end
