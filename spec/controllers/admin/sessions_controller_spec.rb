require 'spec_helper'
require 'form_helper'

describe Admin::SessionsController do
  describe 'GET new' do
    before { get :new }
    it { expect(response).to be_success }
    it { expect(response).to render_template(:new) }
    context 'views' do
      render_views
      it {
        should_have_email_tag('email')
        should_have_password_tag('password')
        should_have_submit_button_tag('ログイン')
      }
    end
  end

  describe 'POST create' do
    let!(:user) { create(:user) }
    context 'login successful' do
      before {
        post :create, email: user.email, password: 'password'
      }
      it { expect(response).to redirect_to admin_dashboard_path }
    end
    context 'login failure' do
      before {
        post :create, email: user.email, password: 'pass'
      }
      it { expect(response).to render_template(:new) }
    end

  end
end
