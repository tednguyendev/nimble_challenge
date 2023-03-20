require 'rails_helper'

RSpec.describe Api::V1::DetailReportPresenter do
  let(:user) { create(:user) }
  let(:report) { create(:report, user: user) }
  let(:keyword) { create(:keyword, report: report) }
  let(:params) { report }

  describe '.json' do
    it 'returns correct data' do
      json_output = described_class.json(params)

      expect(json_output).to eq(
        {
          id: report.id,
          name: report.name,
          status: report.status,
          percentage: report.percentage,
          created_at: report.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          keywords: Api::V1::KeywordPresenter.json(report.keywords.order_by_created_at_ascending)
        }
      )
    end
  end
end
