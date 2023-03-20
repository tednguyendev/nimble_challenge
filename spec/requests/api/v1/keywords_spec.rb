require 'rails_helper'

RSpec.describe Api::V1::KeywordsController do
  let(:failed_result) { {:success=>false, :data=>{}, :errors=>[], :message=>"Something is wrong"} }
  let(:token) { '' }

  describe 'GET api/v1/keywords/:id/html-source' do
    let(:prefix_path) { "/api/v1/keywords/#{keyword.id}/html-source" }

    let(:user) { create(:user, activated: true) }
    let(:report) { create(:report, user: user) }
    let(:html_string) { '<!DOCTYPE html><html><head></head><body><div>hi</div></body></html>' }
    let(:keyword) { create(:keyword, status: Keyword::SUCCESS, html_string: html_string, report: report) }

    context 'unauthorized' do
      it 'returns error' do
        get prefix_path, headers: {'Authorization' => token}
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'authorized' do
      let(:token) { JsonWebToken.encode(user_id: user.id) }

      before do
        allow(Api::V1::Keywords::GetHtmlSource).to receive(:call).and_return(cmd)
      end

      context 'service succeeds' do
        let(:success_result) { {:success=>false, :data=>{ html_string: html_string }, :errors=>[], :message=>""} }
        let(:cmd) { double(success?: true, result: success_result) }

        it 'returns success message' do
          get prefix_path, headers: {'Authorization' => token}
          expect(response.body).to eq(html_string)
        end
      end

      context 'service failed' do
        let(:cmd) { double(success?: false, result: failed_result) }

        it 'returns error' do
          get prefix_path, headers: {'Authorization' => token}
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq(failed_result.to_json)
        end
      end
    end
  end
end
