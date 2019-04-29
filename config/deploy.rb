set :application, 'repairsystem'
set :repo_url, 'git@github.com:EvanBrightside/repair-system.git'

append :linked_files, 'config/database.yml', 'config/secrets.yml', '.env'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'

set :rvm_ruby_version, '2.6.1'

set :db_local_clean, true
set :assets_dir, %w[public/system]

set :sidekiq_config, 'config/sidekiq.yml'

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
