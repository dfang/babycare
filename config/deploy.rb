# config valid only for Capistrano 3.1
lock '3.5.0'

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

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads public/assets vendor/assets/bower_components }

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rbenv_type, :user
set :rbenv_ruby, '2.2.0-dev'
set :rbenv_custom_path, '/opt/rbenv'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"

set :unicorn_user, :deployer
set :templates_path, "config/deploy/templates"
set :nginx_server_name, "wx.yhuan.cc"
set :unicorn_workers, 2

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
namespace :nginx do
  desc 'restart nginx server'
  task :restart do
    on roles(:app) do
      execute 'sudo service nginx restart'
    end
  end

  desc 'stop nginx server'
  task :stop do
    on roles(:app) do
      execute 'sudo service nginx stop'
    end
  end
end

namespace :setup do

end

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
end
