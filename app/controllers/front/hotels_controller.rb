class Front::HotelsController < ::Front::ApplicationController
  before_filter :load_resource, except: [:index]

  def index
  end

  def show
  end

  def stay
    @stay = HotelStay.new(@hotel, params[:year], params[:month])
  end

  private

  def load_resource
    @hotel = Hotel.find(params[:id])
  rescue
    render_404
  end
end