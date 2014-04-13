require 'spec_helper'
require 'form_helper'

describe Admin::AccountsController do
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
        should_have_email_tag('user[email]')
        should_have_password_tag('user[password]')
        should_have_password_tag('user[password_confirmation]')
        should_have_submit_tag('登録')
      end
    end
  end

  describe 'POST create' do
    let(:hotel) { create(:hotel) }
    before {
      expect { post :create, user: attributes_for(:user) }.to change(User, :count).by(1)
    }
    it { expect(response).to redirect_to admin_accounts_path }
  end

  describe 'GET edit' do
    let!(:user) { create(:user) }
    before { get :edit, id: user.id }
    it { expect(response).to render_template(:edit) }
    context 'views' do
      render_views
      it do
        should_have_email_tag('user[email]')
        should_have_password_tag('user[password]')
        should_have_password_tag('user[password_confirmation]')
        should_have_submit_tag('更新')
      end
    end
  end

  describe 'PUT update' do
    let!(:user) { create(:user, email: 'foo@example.com') }
    before {
      expect{
        put :update, id: user.id, user: { email: 'bar@example.com', password: '1234567890', password_confirmation: '1234567890'}
      }.to_not change(User, :count)
    }
    it { expect(response).to redirect_to admin_accounts_path }
    context 'user' do
      before { user.reload }
      it { expect(user.email).to eq 'bar@example.com' }
      it { expect(User.authenticate('bar@example.com', '1234567890')).to be_present }
    end
  end

  describe 'DELETE destroy' do
    let!(:user) { create(:user) }
    before {
      expect{ delete :destroy, id: user.id }.to change(User, :count).by(-1)
    }
    it { expect(response).to redirect_to admin_accounts_path }
  end
end
