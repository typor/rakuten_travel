class Front::DashboardController < ::Front::ApplicationController
  def index
    plan_ids = Plan.enabled.where('gift_price > 0').group(:hotel_id).ids
    @plans = Plan.where(id: plan_ids.sample(8)).includes(:hotel)
    hotel_ids = Hotel.enabled.where('review_average > 380').ids
    @hotels = Hotel.where(id: hotel_ids.sample(8))
  end
end