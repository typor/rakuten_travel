class Admin::ApplicationController < ::ApplicationController
  layout 'admin'
  before_filter :welcome
  before_filter :require_login

  def render_404
    respond_to do |format|
      format.html { render template: "errors/error_404", status: 404 }
      format.any { head :not_found }
    end
  end

  def welcome
    if User.count == 0
      redirect_to admin_welcome_path
    end
  end

  def not_authenticated
    redirect_to admin_login_url, alert: t('global.need_login')
  end
end