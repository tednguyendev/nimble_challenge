require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do
  controller do
    def index
      render text: "Hello World"
    end
  end

  describe 'before actions' do
    context 'user is not authenticated' do
      it 'returns unauthorized error' do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ 'errors' => 'Not Authorized' })
      end
    end

    context 'user is not activated' do
      let(:user) { create(:user, activated: false) }

      before { allow(controller).to receive(:current_user).and_return(user) }

      it 'returns unauthorized error' do
        get :index
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq({ 'errors' => 'This account is not activated yet.' })
      end
    end

    context 'user is authenticated and activated' do
      let(:user) { create(:user, activated: true) }

      before { allow(controller).to receive(:current_user).and_return(user) }

      it 'calls current_user and returns the user' do
        expect(controller.current_user).to eq(user)
      end
    end
  end
end
