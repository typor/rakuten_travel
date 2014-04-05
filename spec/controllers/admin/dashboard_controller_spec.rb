require 'spec_helper'

describe Admin::DashboardController do
  describe 'GET index' do
    context 'not login' do
      context 'exist user' do
        let!(:user) { create(:user) }
        before { get :index }
        it { expect(response).to redirect_to admin_login_path }
      end

      context 'no user' do
        before { get :index }
        it { expect(response).to redirect_to admin_welcome_path }
      end
    end

    context 'logined' do
      before {
        session[:user_id] = create(:user).id
        get :index
      }
      it { expect(response).to be_success }
    end
  end

end
