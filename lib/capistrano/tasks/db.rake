# Hacking.....
namespace :db do
  desc 'pull odoo database after cap db:pull, because there are two databases'
  task :pull_odoo_db do
    on roles(:db) do
      require 'yaml'
      production_config  = capture "cat #{shared_path}/config/database.yml"
      odoo_production    = YAML.safe_load(production_config)['odoo_production']
      local_development  = YAML.load_file('config/database.yml')['odoo_development']
      dump_filename = "/tmp/#{Time.now.to_i}-#{odoo_production['database']}.tar"
      p dump_filename
      cmd = "PGPASSWORD=#{odoo_production['password']} pg_dump -x -h #{odoo_production['host']} -p #{local_development['port']} -U #{odoo_production['username']} -Ft -f #{dump_filename}  #{odoo_production['database']}"
      p cmd
      execute cmd.to_s
      download! dump_filename, dump_filename
      execute "rm #{dump_filename}"

      # 服务器用的9.4版本的postgresql, pg_dump 和 pg_restore 最好用版本一致的
      local_postgresql_path = '/usr/local/Cellar/postgresql@9.4/9.4.11/bin'
      run_locally do
        with rails_env: :development do
          execute "PGPASSWORD=#{local_development['password']} #{local_postgresql_path}/dropdb --if-exists -h #{local_development['host']} -p #{local_development['port']} -U #{local_development['username']} #{local_development['database']}"
          execute "PGPASSWORD=#{local_development['password']} #{local_postgresql_path}/createdb -h #{local_development['host']} -p #{local_development['port']} -U #{local_development['username']} -O #{local_development['username']} #{local_development['database']}"
          execute "PGPASSWORD=#{local_development['password']} #{local_postgresql_path}/pg_restore -c --if-exists -v -h #{local_development['host']} -p #{local_development['port']} -O -U #{local_development['username']} -d #{local_development['database']} -Ft #{dump_filename}"
          execute "rm #{dump_filename}"
        end
      end
    end
  end
  after :pull, :pull_odoo_db
end
