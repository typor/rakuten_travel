require 'spec_helper'
require 'form_helper'

describe Admin::HotelsController do
  before { login }
  describe 'GET index' do
    describe 'views' do
      render_views
      before { get :index }
      it {
        expect(response).to render_template(:index)
        should_have_text_tag 'q[long_name_or_short_name_cont]'
        should_have_select_tag 'q[area_id_eq]'
      }
    end

    describe 'search' do
      let(:area_1) { create(:area) }
      let(:area_2) { create(:area) }
      let!(:hotel_1) { create(:hotel, area: area_1, long_name: 'foo1', short_name: 'baz2') }
      let!(:hotel_2) { create(:hotel, area: area_2, long_name: 'bar1', short_name: 'baz2') }

      let(:hotels) { assigns(:hotels) }
      context 'long_name' do
        before {
          get :index, q: { long_name_or_short_name_cont: 'foo' }
        }
        it {
          expect(hotels.size).to eq 1
          expect(hotels.first.id).to eq hotel_1.id
        }
      end
      context 'short_name' do
        before {
          get :index, q: { long_name_or_short_name_cont: 'baz' }
        }
        it {
          expect(hotels.size).to eq 2
          expect(hotels.first.id).to eq hotel_1.id
          expect(hotels.last.id).to eq hotel_2.id
        }
      end
      context 'area_id' do
        before {
          get :index, q: { area_id_eq: area_1.id }
        }
        it {
          expect(hotels.size).to eq 1
          expect(hotels.first.id).to eq hotel_1.id
        }
      end
    end
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
