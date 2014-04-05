class Admin::WelcomeController < ::Admin::ApplicationController
  layout 'simple'
  skip_before_filter :welcome
  skip_before_filter :require_login
  before_filter :exist_user

  def new
    @user = User.new
  end

  def create
    @user = User.new(request_params)
    if @user.save
      redirect_to admin_login_url, notice: t('admin.welcome.success')
    else
      render :new
    end
  end

  private

  def exist_user
    if User.count > 0
      redirect_to admin_login_path
    end
  end

  def request_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end