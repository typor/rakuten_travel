class Admin::HotelsController < Admin::ApplicationController
  before_filter :load_resource, only: [:edit, :update, :destroy]
  def index
    @hotels = Hotel
    @hotels = @hotels.where(area_id: params[:area_id]) if params[:area_id].present?
    @hotels = @hotels.order(enabled: :desc).page params[:page]
  end

  def new
    @hotel = Hotel.new
  end

  def create
    @hotel = Hotel.new(request_params)
    if @hotel.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @hotel.update(request_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @hotel.destroy
    redirect_to action: :index
  end

  private

  def request_params
    params.require(:hotel).permit(Hotel.new.safe_keys)
  end

  def load_resource
    @hotel = Hotel.find(params[:id])
  rescue
    render_404
  end
end