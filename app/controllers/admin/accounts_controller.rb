class Admin::AccountsController < ::Admin::ApplicationController
  before_filter :load_resource, only: [:show, :edit, :update, :destroy]
  def index
    @users = User.page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(request_params)
    if @user.save
      redirect_to admin_accounts_path, notice: I18n.t('admin.flashes.successful_create', name: @user.email)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(request_params)
      redirect_to admin_accounts_path, notice: I18n.t('admin.flashes.successful_update', name: @user.email)
    else
      render :edit
    end
  end

  def destroy
    if @user.id != current_user.id && @user.destroy
      flash[:notice] = I18n.t('admin.flashes.successful_destroy', name: @user.email)
    end
    redirect_to action: :index
  end

  private

  def request_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def load_resource
    @user = User.find(params[:id])
  rescue
    render_404
  end
end
