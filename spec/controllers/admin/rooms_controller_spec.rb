require 'spec_helper'
require 'form_helper'

describe Admin::RoomsController do
  before { login }
  describe 'GET index' do
    before { get :index }
    it { expect(response).to render_template(:index) }
  end

  describe 'GET new' do
    before { get :new }
    it { expect(response).to render_template(:new) }
    context 'views' do
      render_views
      it do
        should_have_select_tag('room[hotel_id]')
        should_have_text_tag('room[code]')
        should_have_text_tag('room[name]')
        should_have_submit_tag('登録')
      end
    end
  end

  describe 'POST create' do
    let(:hotel) { create(:hotel) }
    before {
      expect { post :create, room: attributes_for(:room, hotel_id: hotel.id) }.to change(Room, :count).by(1)
    }
    it { expect(response).to redirect_to admin_rooms_path }
  end

  describe 'GET edit' do
    let!(:room) { create(:room) }
    before { get :edit, id: room.id }
    it { expect(response).to render_template(:edit) }
    context 'views' do
      render_views
      it do
        should_have_select_tag('room[hotel_id]')
        should_have_text_tag('room[name]')
        should_have_text_tag('room[code]')
        should_have_checkbox_tag('room[smoking]')
        should_have_submit_tag('更新')
      end
    end
  end

  describe 'PUT update' do
    let!(:room) { create(:room, code: 1234567890) }
    before {
      expect{ put :update, id: room.id, room: { code: '12345'} }.to_not change(Room, :count)
    }
    it { expect(response).to redirect_to admin_rooms_path }
    context 'room' do
      before { room.reload }
      it { expect(room.code).to eq "12345" }
    end
  end

  describe 'DELETE destroy' do
    let!(:room) { create(:room) }
    before {
      expect{ delete :destroy, id: room.id }.to change(Room, :count).by(-1)
    }
    it { expect(response).to redirect_to admin_rooms_path }
  end
end
