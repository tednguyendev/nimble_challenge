require 'rails_helper'

RSpec.describe Api::V1::ReportsController do
  let(:success_result) { {:success=>true, :data=>{}, :errors=>[], :message=>""} }
  let(:failed_result) { {:success=>false, :data=>{}, :errors=>[], :message=>"Something is wrong"} }
  let(:user) { create(:user, activated: true) }
  let(:token) { '' }

  describe 'POST /api/v1/reports' do
    let(:prefix_path) { '/api/v1/reports' }

    context 'unauthorized' do
      it 'returns error' do
        post prefix_path, headers: {'Authorization' => token}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'authorized' do
      let(:token) { JsonWebToken.encode(user_id: user.id) }

      before do
        allow(Api::V1::Reports::Create).to receive(:call).and_return(cmd)
      end

      context 'service succeeds' do
        let(:cmd) { double(success?: true, result: success_result) }

        it 'return with correct res' do
          post prefix_path, headers: {'Authorization' => token}
          expect(response).to have_http_status(:ok)
          expect(response.body).to eq(success_result.to_json)
        end
      end

      context 'service failed' do
        let(:cmd) { double(success?: false, result: failed_result) }

        it 'return with correct res' do
          post prefix_path, headers: {'Authorization' => token}
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq(failed_result.to_json)
        end
      end
    end
  end

  describe 'POST /api/v1/reports/:id/retry' do
    let(:report) { create(:report, user: user) }
    let(:prefix_path) { "/api/v1/reports/#{report.id}/retry" }

    context 'unauthorized' do
      it 'returns error' do
        post prefix_path, headers: {'Authorization' => token}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'authorized' do
      let(:token) { JsonWebToken.encode(user_id: user.id) }

      before do
        allow(Api::V1::Reports::RefetchKeywords).to receive(:call).and_return(cmd)
      end

      context 'service succeeds' do
        let(:cmd) { double(success?: true, result: success_result) }

        it 'return with correct res' do
          post prefix_path, headers: {'Authorization' => token}
          expect(response).to have_http_status(:ok)
          expect(response.body).to eq(success_result.to_json)
        end
      end

      context 'service failed' do
        let(:cmd) { double(success?: false, result: failed_result) }

        it 'return with correct res' do
          post prefix_path, headers: {'Authorization' => token}
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq(failed_result.to_json)
        end
      end
    end
  end

  describe 'GET /api/v1/reports' do
    let(:prefix_path) { "/api/v1/reports" }

    context 'unauthorized' do
      it 'returns error' do
        get prefix_path, headers: {'Authorization' => token}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'authorized' do
      let(:token) { JsonWebToken.encode(user_id: user.id) }

      before do
        allow(Api::V1::Reports::List).to receive(:call).and_return(cmd)
      end

      context 'service succeeds' do
        let(:cmd) { double(success?: true, result: success_result) }

        it 'return with correct res' do
          get prefix_path, headers: {'Authorization' => token}
          expect(response).to have_http_status(:ok)
          expect(response.body).to eq(success_result.to_json)
        end
      end

      context 'service failed' do
        let(:cmd) { double(success?: false, result: failed_result) }

        it 'return with correct res' do
          get prefix_path, headers: {'Authorization' => token}
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq(failed_result.to_json)
        end
      end
    end
  end

  describe 'GET /api/v1/reports/:id' do
    let(:report) { create(:report, user: user) }
    let(:prefix_path) { "/api/v1/reports/#{report.id}" }

    context 'unauthorized' do
      it 'returns error' do
        get prefix_path, headers: {'Authorization' => token}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'authorized' do
      let(:token) { JsonWebToken.encode(user_id: user.id) }

      before do
        allow(Api::V1::Reports::Get).to receive(:call).and_return(cmd)
      end

      context 'service succeeds' do
        let(:cmd) { double(success?: true, result: success_result) }

        it 'return with correct res' do
          get prefix_path, headers: {'Authorization' => token}
          expect(response).to have_http_status(:ok)
          expect(response.body).to eq(success_result.to_json)
        end
      end

      context 'service failed' do
        let(:cmd) { double(success?: false, result: failed_result) }

        it 'return with correct res' do
          get prefix_path, headers: {'Authorization' => token}
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq(failed_result.to_json)
        end
      end
    end
  end
end
