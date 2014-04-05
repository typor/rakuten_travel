require 'spec_helper'
require 'form_helper'

describe Admin::WelcomeController do
  describe 'GET new' do
    context 'exist user' do
      let!(:user) { create(:user) }
      before { get :new }
      it { expect(response).to redirect_to admin_login_path }
    end

    render_views
    before { get :new }
    it 'should render form' do
      expect(response).to render_template(:new)
      should_have_email_tag('user[email]')
      should_have_password_tag('user[password]')
      should_have_password_tag('user[password_confirmation]')
      should_have_submit_tag('登録')
    end
  end

  describe 'POST create' do
    it 'should create user' do
      expect{
        post :create, user: {email: 'example@example.com', password: '12345678', password_confirmation: '12345678'}
      }.to change(User, :count).by(1)
      expect(response).to redirect_to admin_login_url
    end

    context 'failure' do
      it 'should render form' do
        expect{
          post :create, user: {email: '', password: '12345678', password_confirmation: '12345678'}
        }.to change(User, :count).by(0)
        expect(response).to render_template(:new)
      end
    end
  end
end
