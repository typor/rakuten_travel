require 'spec_helper'

describe Front::HotelsController do
  describe 'GET show' do
    let!(:hotel) { create(:hotel) }
    before { get :show, id: hotel.id }
    it { expect(response).to render_template(:show) }
  end
end