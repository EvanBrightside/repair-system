source 'https://rubygems.org'
git_source :github do |repo|
  "https://github.com/#{repo}.git"
end

ruby '2.6.1'

gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'dotenv-rails'

# ActiveAdmin
gem 'activeadmin'
gem 'arctic_admin'
gem 'cancan'
gem 'devise'
gem 'activeadmin-searchable_select'
gem 'active_admin_datetimepicker'
gem "active_admin_import" , github: "activeadmin-plugins/active_admin_import"
gem "active_admin-sortable_tree", "~> 2.0.0"

# Scheduled jobs
gem 'whenever', require: false

gem 'enumerize'

gem 'jquery-rails'
gem 'slim-rails'

gem 'redis'
gem 'sidekiq' # Background jobs
gem 'sentry-raven'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rubyzip', '>= 1.2.2'
  gem 'pry'
  gem 'faker'
  gem 'rspec-rails'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'bundler-audit'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
  gem 'guard'
  gem 'guard-livereload', '~> 2.5', require: false
  gem 'meta_request'
  gem 'letter_opener'
  # capistrano
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano3-unicorn', require: false
  gem 'capistrano-sidekiq', require: false

  gem 'pry-rails'
end

group :production do
  gem 'unicorn'
  gem 'therubyracer', platforms: :ruby
end

group :lint do
  gem 'rubocop'
end

gem 'carrierwave'
gem 'mini_magick'
gem 'tzinfo-data', platforms: %w[mingw mswin x64_mingw jruby]
