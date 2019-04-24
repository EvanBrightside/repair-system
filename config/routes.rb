require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  root to: redirect('/admin')
  match '/admin', to: 'admin/dashboard#index', via: :get

  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
