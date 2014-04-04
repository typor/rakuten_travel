require 'spec_helper'

describe Admin::ChargesController do
  before { login }
  describe 'GET index' do
    before { get :index }
    it { expect(response).to render_template(:index) }
  end
end
