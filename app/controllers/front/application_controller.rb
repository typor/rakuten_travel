class Front::ApplicationController < ::ApplicationController
  layout 'front'

  def render_404
    respond_to do |format|
      format.html { render template: "/front/errors/error_404", status: 404 }
      format.any { head :not_found }
    end
  end
end