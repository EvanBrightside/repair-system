server 'repairsystem.ivanzabrodin.com', port: '22251', user: 'app', roles: %w[web app db]

set :keep_releases, 3
set :rails_env, :production
set :branch, :master
set :deploy_to, '/home/app/production'
