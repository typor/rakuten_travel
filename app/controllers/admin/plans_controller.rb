class Admin::PlansController < Admin::ApplicationController
  before_filter :load_resource, only: [:edit, :update, :destroy]

  def index
    @search = Plan.includes(:hotel).search(params[:q])
    @search.sorts = 'id asc' if @search.sorts.empty?
    @plans = @search.result(distinct: true).page params[:page]
  end

  def new
    @plan = Plan.new(hotel_id: params[:hotel_id])
  end

  def create
    @plan = Plan.new(request_params)
    if @plan.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @plan.update(request_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @plan.destroy
    redirect_to action: :index
  end

  private

  def request_params
    params.require(:plan).permit(Plan.safe_keys)
  end

  def load_resource
    @plan = Plan.find(params[:id])
  rescue
    render_404
  end
end
