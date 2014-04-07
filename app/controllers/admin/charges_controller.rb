class Admin::ChargesController < Admin::ApplicationController
  def index
    @charges = Charge.includes(:hotel, :room, :plan)
    @charges = @charges.where(hotel_id: params[:hotel_id]) if params[:hotel_id]
    @charges = @charges.order(stay_day: :asc).page params[:page]
  end
end
