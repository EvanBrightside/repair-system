server 'repairsystem.ivanzabrodin.com', user: 'app', roles: %w[web app db]

set :keep_releases, 3
set :rails_env, :production
set :branch, :master
set :deploy_to, '/home/app/production'
