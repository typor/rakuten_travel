class Admin::SessionsController < ::Admin::ApplicationController
  skip_before_filter :require_login, except: :destroy
  layout 'simple'

  def new
  end

  def create
    if login(params[:email], params[:password])
      redirect_back_or_to admin_dashboard_path, notice: t('global.login_successful')
    else
      flash.now.alert = t('global.login_failure')
      render :new
    end
  end

  def destroy
  end
end