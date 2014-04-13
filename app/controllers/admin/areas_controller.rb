class Admin::AreasController < ::Admin::ApplicationController
  before_filter :load_resource, except: [:index, :new, :create, :import]
  def index
    @search = Area.search(params[:q])
    @search.sorts = 'id asc' if @search.sorts.empty?
    @areas = @search.result.page params[:page]
  end

  def new
    @area = Area.new
  end

  def create
    @area = Area.new(request_params)
    if @area.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @area.update(request_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    @area.destroy
    redirect_to action: :index
  end

  def import_hotels
    job_id = ImportHotelsByAreaWorker.perform_async(@area.id)
    if job_id
      flash[:notice] = I18n.t('sidekiq.successful_perform_async', job_id: job_id)
    else
      flash[:error] = I18n.t('sidekiq.failure_perform_async')
    end
  rescue Exception => e
    Rails.logger.fatal "[#{self.class.to_s}] " + e.backtrace.join("\n")
    flash[:error] = I18n.t('sidekiq.failure_perform_async')
  ensure
    redirect_to action: :index
  end

  def toggle
    status = @area.update(enabled: @area.enabled ? false : true)
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.json { render json: {status: status, enabled: @area.enabled} }
    end
  end

  def import
    job_id = ImportAreasWorker.perform_async
    if job_id
      flash[:notice] = I18n.t('sidekiq.successful_perform_async', job_id: job_id)
    else
      flash[:error] = I18n.t('sidekiq.failure_perform_async')
    end
  rescue Exception => e
    Rails.logger.fatal "[#{self.class.to_s}] " + e.backtrace.join("\n")
    flash[:error] = I18n.t('sidekiq.failure_perform_async')
  ensure
    redirect_to action: :index
  end

  private

  def request_params
    params.require(:area).permit(:long_name, :short_name, :large, :middle, :small, :detail, :enabled)
  end

  def load_resource
    @area = Area.find(params[:id])
  rescue
    render_404
  end
end