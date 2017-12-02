# frozen_string_literal: true
# # frozen_string_literal: true
#
# Rake::Task['deploy:assets:prepare'].clear_actions
#
# namespace :deploy do
#   namespace :assets do
#     desc 'Overwrite prepare task in asses_local_precompile gem '
#     task :prepare do
#       # execute :bundle, 'exec rake assets:clean'
#       # execute :bundle, 'exec rake assets:precompile'
#       sh 'RAILS_ENV=production bin/bundle exec rake assets:clean'
#       sh 'RAILS_ENV=production bin/bundle exec rake assets:precompile'
#     end
#   end
# end
