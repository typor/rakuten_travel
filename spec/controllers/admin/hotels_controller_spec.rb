require 'spec_helper'

describe Admin::HotelsController do
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
    let(:area) { create(:area) }
    before {
      post :create, hotel: attributes_for(:hotel, area_id: area.id)
    }
    it { expect(response).to redirect_to admin_hotels_path }
  end

  describe 'GET edit' do
    let!(:hotel) { create(:hotel) }
    before { get :edit, id: hotel.id }
    it { expect(response).to render_template(:edit) }
  end

  describe 'PUT update' do
    let!(:hotel) { create(:hotel, no: '1234567890') }
    it {
      expect{ put :update, id: hotel.id, hotel: { no: '12345'} }.to_not change(Hotel, :count)
      expect(response).to redirect_to admin_hotels_path
      hotel.reload
      expect(hotel.no).to eq '12345'
    }
  end

  describe 'DELETE destroy' do
    let!(:hotel) { create(:hotel) }
    it {
      expect{ delete :destroy, id: hotel.id }.to change(Hotel, :count).by(-1)
      expect(response).to redirect_to admin_hotels_path
    }
  end
end
