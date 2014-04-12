class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'application'

  def render_404
    respond_to do |format|
      format.html { render template: "errors/error_404", status: 404 }
      format.any { head :not_found }
    end
  end
end
