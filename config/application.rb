# frozen_string_literal: true

require_relative 'boot'

# require 'rails/all'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
# require "rails/test_unit/railtie"
require 'action_cable/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Babycare
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths += %W[#{config.root}/lib #{config.root}/lib/extras #{config.root}/lib/weixin]
    config.eager_load_paths += %W[#{config.root}/lib #{config.root}/lib/extras #{config.root}/lib/weixin]

    config.autoload_paths << Rails.root.join('app/graphql/interfaces')
    config.autoload_paths << Rails.root.join('app/graphql/basic_types')

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Beijing'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :'zh-CN'

    config.assets.initialize_on_precompile = false

    # config.assets.paths << Rails.root.join("app", "assets", "fonts")
    # config.assets.paths << Rails.root.join("lib", "assets", "fonts")

    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
      g.helper false
      g.test false
    end
  end
end
