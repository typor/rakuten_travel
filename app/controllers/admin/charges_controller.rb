class Admin::ChargesController < Admin::ApplicationController
  def index
    @charges = Charge.includes(:hotel, :room, :plan).order(id: :asc).page params[:page]
  end
end
