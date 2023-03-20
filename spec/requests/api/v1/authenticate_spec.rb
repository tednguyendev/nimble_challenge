require 'rails_helper'

RSpec.describe Api::V1::AuthenticateController do
  let(:success_result) { {:success=>true, :data=>{}, :errors=>[], :message=>""} }
  let(:failed_result) { {:success=>false, :data=>{}, :errors=>[], :message=>"Something is wront"} }

  describe 'POST /api/v1/sign-up' do
    let(:prefix_path) { '/api/v1/sign-up' }

    before do
      allow(Api::V1::Authenticate::SignUp).to receive(:call).and_return(cmd)
    end

    context 'service succeeds' do
      let(:cmd) { double(success?: true, result: success_result) }

      it 'returns success message' do
        post prefix_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(success_result.to_json)
      end
    end

    context 'service failed' do
      let(:cmd) { double(success?: false, result: failed_result) }

      it 'returns error' do
        post prefix_path
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq(failed_result.to_json)
      end
    end
  end

  describe 'GET /api/v1/verify-email' do
    let(:prefix_path) { '/api/v1/verify-email' }

    before do
      allow(Api::V1::Authenticate::VerifyEmail).to receive(:call).and_return(cmd)
    end

    context 'service succeeds' do
      let(:cmd) { double(success?: true, result: success_result) }

      it 'redirect with correct status' do
        get prefix_path
        expect(response).to redirect_to("#{ENV['FRONT_END_ENDPOINT']}/sign-in?status=success")
      end
    end

    context 'service failed' do
      let(:cmd) { double(success?: false, result: failed_result) }

      it 'redirect with correct status' do
        get prefix_path
        expect(response).to redirect_to("#{ENV['FRONT_END_ENDPOINT']}/sign-in?status=fail")
      end
    end
  end

  describe 'POST /api/v1/sign-in' do
    let(:prefix_path) { '/api/v1/sign-in' }

    before do
      allow(Api::V1::Authenticate::SignIn).to receive(:call).and_return(cmd)
    end

    context 'service succeeds' do
      let(:cmd) { double(success?: true, result: success_result) }

      it 'returns success message' do
        post prefix_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(success_result.to_json)
      end
    end

    context 'service failed' do
      let(:cmd) { double(success?: false, result: failed_result) }

      it 'returns error' do
        post prefix_path
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq(failed_result.to_json)
      end
    end
  end
end
