# coding: utf-8
# frozen_string_literal: true

# config valid only for Capistrano 3.1
lock '3.7'

set :application, 'callmeadoctor'
# set :repo_url, 'git@git.coding.net:df1228/callmeadoctor.git'
set :repo_url, 'git@github.com:dfang/babycare.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :branch, :develop

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deployer/apps/callmeadoctor'

set :db_local_clean, false
set :deploy_user, :deployer

set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
set :backup_path, "/home/#{fetch(:deploy_user)}/Backup"

set :ssh_options, forward_agent: true
set :default_run_options, pty: true

set :linked_files, %w[config/database.yml config/secrets.yml]
# http://stackoverflow.com/questions/26151443/capistrano-3-deployment-for-rails-4-binstubs-conflict
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads public/assets vendor/assets/bower_components node_modules]
set :bundle_binstubs, nil

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

###### config rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.3.0'
set :rbenv_custom_path, '/opt/rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

###### config puma and nginx
set :nginx_roles, :web

# set :unicorn_user, :deployer
# set :unicorn_workers, 2
set :puma_user, :deployer
set :templates_path, 'config/deploy/templates'

# set :puma_nginx, :deployer
set :puma_nginx, :web
set :nginx_sites_available_path, '/etc/nginx/sites-available'
set :nginx_sites_enabled_path, '/etc/nginx/sites-enabled'
set :nginx_config_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :nginx_server_name, 'wx.baojiankang.cc'

set :puma_conf, "#{shared_path}/config/puma.rb"
set :puma_workers, 1
set :puma_bind,       "unix:///#{shared_path}/tmp/sockets/puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, false
set :puma_worker_timeout, nil
set :puma_init_active_record, true

namespace :deploy do
  # ensure_enough_memory for deploy:assets:precompile
  before :starting, 'puma:stop'
  before :starting, :ensure_enough_memory do
    on roles(:app) do
      execute 'sudo service redis-server stop'
      execute 'sudo service postgresql stop'
      execute 'sudo service nginx stop'
    end
  end
  after 'deploy:assets:backup_manifest', :start_server_again do
    on roles(:app) do
      execute 'sudo service postgresql start'
      execute 'sudo service redis-server start'
      execute 'sudo service nginx start'
    end
  end

  before 'deploy:migrate', :start_postgresql do
    on roles(:db) do
      execute 'sudo service postgresql start'
    end
  end

  before 'check:linked_files', 'puma:config'
  before 'check:linked_files', 'puma:nginx_config'
  after  'puma:smart_restart', 'nginx:restart'
end

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

namespace :deploy do
  desc 'Setup everything needed before deploy ..........................'
  task :setup do
    invoke 'secrets_yml:setup'
    invoke 'postgresql:setup'
    invoke 'deploy:check'
    invoke 'nginx:setup'
    # invoke "unicorn:setup_app_config"
    # invoke "unicorn:setup_initializer"
  end
end
