require 'spec_helper'

describe Admin::AreasController do
  before { login }
  describe 'GET index' do
    before { get :index }
    it { expect(response).to render_template(:index) }
  end

  describe 'GET new' do
    before { get :new }
    it { expect(response).to render_template(:new) }
  end

  describe 'POST create' do
    before {
      post :create, area: {
        long_name: 'foo', short_name: 'bar', large: 'japan', middle: 'tokyo', small: 'tokyo'
      }
    }
    it { expect(response).to redirect_to admin_areas_path }
  end

  describe 'GET edit' do
    let!(:area) { create(:area) }
    before { get :edit, id: area.id }
    it { expect(response).to render_template(:edit) }
  end

  describe 'PUT update' do
    let!(:area) { create(:area, long_name: 'foo') }
    it {
      expect{ put :update, id: area.id, area: { long_name: 'bar'} }.to_not change(Area, :count)
      expect(response).to redirect_to admin_areas_path
      area.reload
      expect(area.long_name).to eq 'bar'
    }
  end

  describe 'DELETE destroy' do
    let!(:area) { create(:area) }
    it {
      expect{ delete :destroy, id: area.id }.to change(Area, :count).by(-1)
      expect(response).to redirect_to admin_areas_path
    }
  end
end
