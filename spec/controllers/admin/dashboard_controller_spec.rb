require 'spec_helper'

describe Admin::DashboardController do
  describe 'GET index' do
    context 'not login' do
      before { get :index }
      it { expect(response).to redirect_to admin_login_path }
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
