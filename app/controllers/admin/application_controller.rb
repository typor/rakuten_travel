class Admin::ApplicationController < ::ApplicationController
  before_filter :require_login

  def not_authenticated
    redirect_to admin_login_url, alert: t('global.need_login')
  end
end