class Admin::ApplicationController < ::ApplicationController
  before_filter :welcome
  before_filter :require_login

  def welcome
    if User.count == 0
      redirect_to admin_welcome_path
    end
  end

  def not_authenticated
    redirect_to admin_login_url, alert: t('global.need_login')
  end
end