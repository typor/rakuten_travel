class Front::HotelsController < ::Front::ApplicationController
  def index
    @areas = Area.enabled.select('id, short_name')
    @hotels = Hotel.enabled
    if params[:area]
      @area = Area.find_by(short_name: params[:area])
      @hotels = @hotels.where(area_id: @area.id) if @area
    end

    @hotels = @hotels.where("long_name LIKE :name", name: '%' + params[:q] + '%') if params[:q] && params[:q].length >= 3
    @hotels = @hotels.page params[:page]
  end

  def show
    @hotel = Hotel.enabled.find_by(["long_name = :id OR short_name = :id", id: params[:id]])
    if @hotel.nil?
      render_404
    end
  end

  def stay
    render_404 unless request.xhr?
    @hotel = Hotel.enabled.find(params[:id])
    @results = HotelStay.new(hotel: @hotel, year: params[:year], month: params[:month]).search
    raise 'not found' if @results.nil?
    add_xrobots_tag
  rescue
    render_404
  end

end