require 'spec_helper'

describe Front::HotelsController do
  describe 'GET index' do
    let!(:area1) { create(:area) }
    let!(:area2) { create(:area) }
    let!(:area3) { create(:area, enabled: false) }
    let!(:hotels_1) { 2.times {|i| create(:hotel, long_name: 'hotels_1_ ' + i.to_s, area: area1) } }
    let!(:hotels_2) { 2.times {|i| create(:hotel, long_name: 'hotels_2_ ' + i.to_s,area: area2) } }
    let!(:hotel_3) { create(:hotel, area: area3, enabled: false) }

    subject(:hotels) { assigns(:hotels) }
    subject(:areas) { assigns(:areas) }
    subject(:area) { assigns(:area) }

    context 'default' do
      before {
        get :index
      }
      it { expect(response).to render_template(:index) }
      it { expect(hotels.size).to eq 4 }
      it { expect(area).to be_nil }
      it { expect(areas.size).to eq 2 }
    end

    context 'filtered by area' do
      before {
        get :index, area: area1.short_name
      }
      it { expect(response).to render_template(:index) }
      it { expect(hotels.size).to eq 2 }
      it { expect(area.id).to eq area1.id }
    end

    context 'has query' do
      before {
        get :index, q: 'hotels_2'
      }
      it { expect(response).to render_template(:index) }
      it { expect(hotels.size).to eq 2 }
      it { expect(area).to be_nil }
    end
  end

  describe 'GET show' do
    let!(:hotel) { create(:hotel, enabled: true) }
    before { get :show, id: hotel.long_name }
    it { expect(response).to render_template(:show) }
  end
end