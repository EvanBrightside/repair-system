require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, ActiveAdmin::Devise.config

  root to: redirect('/admin')
  match '/admin', to: 'admin/dashboard#index', via: :get

  scope ':locale', defaults: { locale: I18n.locale } do
    ActiveAdmin.routes(self)
  end
end
