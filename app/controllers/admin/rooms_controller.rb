class Admin::RoomsController < Admin::ApplicationController
  before_filter :load_resource, only: [:edit, :update, :destroy]

  def index
    @rooms = Room.includes(:hotel).order(id: :asc).page params[:page]
  end

  def new
    @room = Room.new(hotel_id: params[:hotel_id])
  end

  def create
    @room = Room.new(request_params)
    if @room.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @room.update(request_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @room.destroy
    redirect_to action: :index
  end

  private

  def request_params
    params.require(:room).permit(Room.safe_keys)
  end

  def load_resource
    @room = Room.find(params[:id])
  rescue
    render_404
  end
end
