require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module RepairSystem
  class Application < Rails::Application
    config.load_defaults 5.2
    config.i18n.default_locale = :en
    config.i18n.available_locales = %w[en ru]
    config.active_job.queue_adapter = :sidekiq
  end
end
