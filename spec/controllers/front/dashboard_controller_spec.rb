require 'spec_helper'

describe Front::DashboardController do
  describe 'GET index' do
    render_views
    before {
      get :index
    }
    it { expect(response).to render_template(:index) }
  end
end