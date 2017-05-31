# config valid only for Capistrano 3.1
lock '3.7'

set :application, 'callmeadoctor'
set :repo_url, 'git@git.coding.net:df1228/callmeadoctor.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deployer/apps/callmeadoctor'

set :db_local_clean, false
set :deploy_user, :deployer
set :backup_path, "/home/#{fetch(:deploy_user)}/Backup"

set :ssh_options, {:forward_agent => true}
set :default_run_options, {:pty => true}

set :linked_files, %w{config/database.yml config/secrets.yml}
# http://stackoverflow.com/questions/26151443/capistrano-3-deployment-for-rails-4-binstubs-conflict
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads public/assets vendor/assets/bower_components node_modules}
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
set :templates_path, "config/deploy/templates"

# set :puma_nginx, :deployer
set :puma_nginx, :web
set :nginx_sites_available_path, "/etc/nginx/sites-available"
set :nginx_sites_enabled_path, "/etc/nginx/sites-enabled"
set :nginx_config_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :nginx_server_name, "wx.yhuan.cc"

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

  before 'check:linked_files', 'puma:config'
  before 'check:linked_files', 'puma:nginx_config'
  after 'puma:smart_restart', 'nginx:restart'
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

# nginx
# namespace :nginx do
#   desc 'restart nginx server'
#   task :restart do
#     on roles(:app) do
#       execute 'sudo service nginx restart'
#     end
#   end
#
#   desc 'stop nginx server'
#   task :stop do
#     on roles(:app) do
#       execute 'sudo service nginx stop'
#     end
#   end
# end

# logs
namespace :logs do
  desc "tail log, in zsh, you need to quote your task, eg cap staging 'logs:tail[production]', replace production to unicorn or nginx.access or nginx.error"
  task :tail, :file do |t, args|
    if args[:file]
      on roles(:app) do
        execute "tail -f #{shared_path}/log/#{args[:file]}.log"
      end
    else
      puts "please specify a logfile e.g: 'rake logs:tail[logfile]"
      puts "will tail 'shared_path/log/logfile.log'"
      puts "remember if you use zsh you'll need to format it as:"
      puts "rake 'logs:tail[logfile]' (single quotes)"
    end
  end

  desc "tail rails logs"
  task :rails do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end

  desc "tail nginx access log"
  task :nginx do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/nginx.access.log"
    end
  end

  desc "tail unicorn log"
  task :unicorn do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/unicorn.log"
    end
  end
end


namespace :deploy do
  desc 'Setup everything needed before deploy ..........................'
  task :setup do
    invoke "secrets_yml:setup"
    invoke "postgresql:setup"
    invoke "deploy:check"
    invoke "nginx:setup"
    # invoke "unicorn:setup_app_config"
    # invoke "unicorn:setup_initializer"
  end
end


# Hacking.....
namespace :db do
  desc "pull odoo database after cap db:pull, because there are two databases"
  task :pull_odoo_db do
    on roles(:db) do
      require 'yaml'
      production_config  = capture "cat #{shared_path}/config/database.yml"
      odoo_production    = YAML::load(production_config)["odoo_production"]
      local_development  = YAML::load_file("config/database.yml")["odoo_development"]
      dump_filename = "/tmp/#{Time.now.to_i}-#{odoo_production["database"]}.tar"
      p dump_filename
      cmd = "PGPASSWORD=#{odoo_production['password']} pg_dump -x -h #{odoo_production['host']} -p #{local_development['port']} -U #{odoo_production['username']} -Ft -f #{dump_filename}  #{odoo_production['database']}"
      p cmd
      execute "#{cmd}"
      download! dump_filename, dump_filename
      execute "rm #{dump_filename}"

      # 服务器用的9.4版本的postgresql, pg_dump 和 pg_restore 最好用版本一致的
      local_postgresql_path = "/usr/local/Cellar/postgresql@9.4/9.4.11/bin"
      run_locally do
        with rails_env: :development do
          execute "PGPASSWORD=#{local_development['password']} #{local_postgresql_path}/dropdb --if-exists -h #{local_development['host']} -p #{local_development['port']} -U #{local_development['username']} #{local_development['database']}"
          execute "PGPASSWORD=#{local_development['password']} #{local_postgresql_path}/createdb -h #{local_development['host']} -p #{local_development['port']} -U #{local_development['username']} -O #{local_development["username"]} #{local_development['database']}"
          execute "PGPASSWORD=#{local_development['password']} #{local_postgresql_path}/pg_restore -c --if-exists -v -h #{local_development['host']} -p #{local_development['port']} -O -U #{local_development["username"]} -d #{local_development["database"]} -Ft #{dump_filename}"
          execute "rm #{dump_filename}"
        end
      end
    end
  end
  after :pull, :pull_odoo_db
end
