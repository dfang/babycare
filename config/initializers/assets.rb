# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w[admin.css admin.js]
Rails.application.config.assets.precompile += %w[mobile.js mobile.css uploader.js]
Rails.application.config.assets.precompile += %w[bootstrap_fontawesome]

# Adding Webfonts to the Asset Pipeline
# this one failed
# Rails.application.config.assets.precompile << proc do |path|
#   true if path.match?(/\.(eot|svg|ttf|woff)\z/)
# end

Rails.application.config.assets.precompile << proc { |path|
  true if path.match?(/\.(eot|svg|ttf|woff)\z/)
}
