class Front::DashboardController < ::Front::ApplicationController
  def index
    ids = Plan.enabled.where('gift_price > 0').group(:hotel_id).ids
    @plans = Plan.where(id: ids.sample(9)).includes(:hotel)
  end
end