require 'rails_helper'

RSpec.describe Api::V1::KeywordPresenter do
  let(:user) { create(:user) }
  let(:report) { create(:report, user: user) }
  let(:keyword) { create(:keyword, report: report) }
  let(:params) { keyword }

  describe '.json' do
    it 'returns correct data' do
      json_output = described_class.json(params)

      expect(json_output).to eq(
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
      )
    end
  end
end
