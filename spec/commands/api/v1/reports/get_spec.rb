require 'rails_helper'

RSpec.describe Api::V1::Reports::Get, type: :model do
  describe '#call' do
    let(:params) do
      {
        id: report_id,
        current_user: user
      }
    end

    let!(:user) { create(:user) }
    let!(:report) { create(:report, name: 'b', user: user) }
    let!(:report_id) { report.id }

    let!(:keyword1) { create(:keyword, value: 'a', report: report) }
    let!(:keyword2) { create(:keyword, value: 'b', report: report) }
    let!(:keyword3) { create(:keyword, value: 'c', report: report) }

    subject(:command) { described_class.new(params) }

    context 'the report not exists' do
      let(:report_id) { 123 }

      it 'fails' do
        expect(command.call.success?).to be false
      end

      it 'returns an error message in the response' do
        expect(command.call.result[:message]).to eq('Report not exists.')
      end
    end

    context 'the report exists' do
      it 'succeeds' do
        expect(command.call.success?).to be true
      end

      it 'returns correct data' do
        result = command.call.result[:data][:record]

        expect(result[:id]).to eq(report.id)
        expect(result[:name]).to eq(report.name)
        expect(result[:status]).to eq(report.status)
        expect(result[:percentage]).to eq(report.percentage)
        expect(result[:created_at]).to eq(report.created_at.strftime('%Y-%m-%d %H:%M:%S'))

        expected_keywords = report.keywords.map do |keyword|
          {
            id: keyword.id,
            created_at: keyword.created_at.strftime('%Y-%m-%d %H:%M:%S'),
            value: keyword.value,
            ad_words_count: keyword.ad_words_count,
            links_count: keyword.links_count,
            total_results: keyword.total_results,
            search_time: keyword.search_time,
            status: keyword.status,
            origin_page: "https://www.google.com/search?q=#{URI.encode(keyword.value)}"
          }
        end

        expect(result[:keywords]).to eq(expected_keywords)
      end
    end
  end
end
