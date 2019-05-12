server '10.1.1.246', user: 'app', roles: %w[web app db]
set :keep_releases, 3
set :rails_env, :production
set :branch, :master
set :deploy_to, '/home/app/production'
set :gateway, 'bastion.molinos.ru -p 33112'
set :user, 'app'

# append :linked_files, '.env.production.local'

set :ssh_options,
  user: fetch(:user),
  forward_agent: false,
  proxy: Net::SSH::Proxy::Command.new(
    "ssh -l #{fetch(:user)} #{fetch(:gateway)} -W %h:%p"
  )
