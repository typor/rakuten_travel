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

  describe 'GET import_hotels' do
    let!(:area) { create(:area) }
    before {
      expect {
        get :import_hotels, id: area.id
      }.to change(ImportHotelsByAreaWorker.jobs, :size).by(1)
    }
    it {
      expect(response).to redirect_to admin_areas_path
      expect(flash[:notice]).to be
    }
  end

  describe 'GET toggle' do
    context 'enabled is  is true' do
      let!(:area) { create(:area, enabled: true) }
      before {
        get :toggle, id: area.id, format: :json
      }
      it {
        json = JSON.parse(response.body)
        expect(json['status']).to eq true
        expect(json['enabled']).to eq false
      }
    end
    context 'enabled is false' do
      let!(:area) { create(:area, enabled: false) }
      before {
        get :toggle, id: area.id, format: :json
      }
      it {
        json = JSON.parse(response.body)
        expect(json['status']).to eq true
        expect(json['enabled']).to eq true
      }
    end
  end

  describe 'GET import' do
    before {
      expect {
        get :import
      }.to change(ImportAreasWorker.jobs, :size).by(1)
    }
    it {
      expect(response).to redirect_to admin_areas_path
      expect(flash[:notice]).to be
    }
  end

  describe '404' do
    context 'html' do
      before {
        get :toggle, id: 0
      }
      it { expect(response).to render_template('errors/error_404') }
    end

    context 'json' do
      before {
        get :toggle, id: 0, format: :json
      }
      it { expect(response).to be_not_found }
    end
  end
end
