require 'rails_helper'

RSpec.describe Api::V1::Keywords::GetHtmlSource, type: :model do
  describe '#call' do
    let(:params) do
      {
        id: keyword_id,
        current_user: user
      }
    end

    let(:user) { create(:user) }
    let(:report) { create(:report, user: user) }

    let(:html_string) { File.open(Rails.root.join('spec', 'mocks', 'crawl_api_google.html'), 'r').read }
    let(:keyword) { create(:keyword, value: 'a', status: Keyword::SUCCESS, html_string: html_string, report: report) }
    let(:keyword_id) { keyword.id }

    subject(:command) { described_class.new(params) }

    context 'the keyword not exists' do
      let(:keyword_id) { 123 }

      it 'fails' do
        expect(command.call.success?).to be false
      end

      it 'returns an error message in the response' do
        expect(command.call.result[:message]).to eq('Keyword not exists.')
      end
    end

    context 'the keyword exists' do
      it 'succeeds' do
        expect(command.call.success?).to be true
      end

      it 'returns correct data' do
        result = command.call.result[:data]

        expect(result[:html_string]).to eq(html_string)
      end
    end
  end
end
