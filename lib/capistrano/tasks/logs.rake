namespace :logs do
  desc "tail log, in zsh, you need to quote your task, eg cap staging 'logs:tail[production]', replace production to unicorn or nginx.access or nginx.error"
  task :tail, :file do |_t, args|
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

  desc 'tail rails logs'
  task :rails do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log"
    end
  end

  desc 'tail nginx access log'
  task :nginx do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/nginx.access.log"
    end
  end

  desc 'tail unicorn log'
  task :unicorn do
    on roles(:app) do
      execute "tail -f #{shared_path}/log/unicorn.log"
    end
  end
end
