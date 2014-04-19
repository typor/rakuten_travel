class Front::HotelsController < ::Front::ApplicationController

  def index
  end

  def show
    @hotel = Hotel.find(params[:id])
  rescue
    render_404
  end
end