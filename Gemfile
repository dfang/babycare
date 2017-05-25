source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.1'
gem 'pg', '~> 0.18'
# gem 'puma', '~> 3.7'

gem 'webpacker', github: 'rails/webpacker'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'

gem 'turbolinks', '~> 5'
# gem 'jbuilder', '~> 2.5'

# gem 'unicorn'

# http://stackoverflow.com/questions/15165260/rails-observer-alternatives-for-4-0
gem 'rails-observers', github: 'rails/rails-observers'

gem 'rqrcode'
# gem 'rqrcode_png'

gem 'httparty', '~> 0.13.7'

gem 'devise'
gem 'inherited_resources'
gem 'friendly_id'
gem 'config'

gem 'has_scope'
gem 'exception_notification'
gem 'china_region_fu'
gem 'stringex'
# gem 'public_activity'

gem 'aasm'
gem 'enumerize'

# gem 'paranoia'
gem 'acts-as-taggable-on'
# gem 'ancestry'
# gem 'awesome_nested_set'

gem 'wx_pay'

gem 'jquery-validation-rails'
gem 'haml-rails'
gem 'kaminari'
gem 'simple_form'
gem 'nested_form'
# gem 'cocoon'
gem 'holder_rails'
gem 'tinymce-rails'

gem 'qiniu'
gem 'carrierwave', '~> 1.0'
gem 'carrierwave-qiniu'
gem 'mini_magick'

gem 'carrierwave-data-uri'

# gem 'smart_sms'

gem 'browser'
gem 'websocket-rails'
gem 'wicked'

gem 'pundit'
gem 'omniauth'
gem 'omniauth-wechat-oauth2'


# create test data on server, tempary moved out of development group
gem 'ffaker'
gem 'factory_girl_rails'
gem 'rspec-rails'
gem 'database_cleaner'

gem 'pry-rails'
gem 'pry-remote'

group :development do
  # gem 'web-console', '~> 2.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'nifty-generators', github: 'dfang/nifty-generators'
  gem 'annotate'
  gem 'capistrano', '3.5.0'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  # gem 'capistrano3-puma', '~> 0.6.1'

  gem 'capistrano-postgresql', '~> 4.2.0'
  # gem 'capistrano-faster-assets'
  gem 'capistrano-safe-deploy-to', '~> 1.1.1'
  gem 'capistrano-secrets-yml'

  gem 'capistrano-nginx-unicorn'
  # gem 'capistrano-db-tasks', github: 'dfang/capistrano-db-tasks', branch: 'master', require: false
  gem 'capistrano-db-tasks', require: false
end

# gem 'mocha', group: :test
