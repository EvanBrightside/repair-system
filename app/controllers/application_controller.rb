class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def set_locale
    I18n.default_locale
  end
end
