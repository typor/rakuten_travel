class Admin::ChargesController < Admin::ApplicationController
  def index
    @search = Charge.includes(:hotel, :plan, :room).search(params[:q])
    @search.sorts = 'stay_day asc' if @search.sorts.empty?
    @charges = @search.result.page params[:page]
  end
end
