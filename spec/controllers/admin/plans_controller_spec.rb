require 'spec_helper'
require 'form_helper'

describe Admin::PlansController do
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
        should_have_text_tag('plan[long_name]')
        should_have_text_tag('plan[short_name]')
        should_have_number_tag('plan[point_rate]')
        should_have_submit_tag('登録')
      end
    end
  end

  describe 'POST create' do
    let(:hotel) { create(:hotel) }
    before {
      expect { post :create, plan: attributes_for(:plan, hotel_id: hotel.id) }.to change(Plan, :count).by(1)
    }
    it { expect(response).to redirect_to admin_plans_path }
  end

  describe 'GET edit' do
    let!(:plan) { create(:plan) }
    before { get :edit, id: plan.id }
    it { expect(response).to render_template(:edit) }
    context 'views' do
      render_views
      it do
        should_have_text_tag('plan[long_name]')
        should_have_text_tag('plan[short_name]')
        should_have_number_tag('plan[point_rate]')
        should_have_submit_tag('更新')
      end
    end
  end

  describe 'PUT update' do
    let!(:plan) { create(:plan, code: 1234567890) }
    before {
      expect{ put :update, id: plan.id, plan: { code: '12345'} }.to_not change(Plan, :count)
    }
    it { expect(response).to redirect_to admin_plans_path }
    context 'plan' do
      before { plan.reload }
      it { expect(plan.code).to eq 12345 }
    end
  end

  describe 'DELETE destroy' do
    let!(:plan) { create(:plan) }
    before {
      expect{ delete :destroy, id: plan.id }.to change(Plan, :count).by(-1)
    }
    it { expect(response).to redirect_to admin_plans_path }
  end
end
