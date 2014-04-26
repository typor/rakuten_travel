class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'application'

  def add_xrobots_tag(type = nil)
    type ||= 'noindex,nofollow,noarchive'
    response.headers['X-Robots-Tag'] = type
  end
end
