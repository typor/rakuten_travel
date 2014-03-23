class AreasController < ApplicationController
  before_filter :load_resource, only: [:edit, :update, :destroy]
  def index
    @areas = Area.order(:id).page params[:page]
  end

  def new
    @area = Area.new
  end

  def create
    @area = Area.new(request_params)
    if @area.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @area.update(request_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @area.destroy
    redirect_to action: :index
  end

  private

  def request_params
    params.require(:area).permit(:name, :large, :middle, :small, :detail)
  end

  def load_resource
    @area = Area.find(params[:id])
  rescue
    render_404
  end
end