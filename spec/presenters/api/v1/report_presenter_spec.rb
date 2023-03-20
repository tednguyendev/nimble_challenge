require 'rails_helper'

RSpec.describe Api::V1::ReportPresenter do
  let(:user) { create(:user) }
  let(:report) { create(:report, name: 'b', user: user) }
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
          created_at: report.created_at.strftime('%Y-%m-%d %H:%M:%S')
        }
      )
    end
  end
end
