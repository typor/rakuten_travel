class Admin::ChargesController < Admin::ApplicationController
  before_filter :load_resource, except: [:index]

  def index
    @search = Charge.includes(:hotel, :plan, :room).search(params[:q])
    @search.sorts = 'stay_day asc' if @search.sorts.empty?
    @charges = @search.result.page params[:page]
  end

  def show
  end

  private

  def load_resource
    @charge = Charge.find(params[:id])
  rescue
    render_404
  end
end
