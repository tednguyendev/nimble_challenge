require 'rails_helper'

RSpec.describe Api::V1::Reports::RefetchKeywords, type: :model do
  describe '#call' do
    let(:params) do
      {
        id: report.id,
        current_user: user
      }
    end

    let!(:user) { create(:user) }
    let!(:report) { create(:report, name: 'b', user: user) }

    let!(:keyword1) { create(:keyword, report: report, status: :success) }
    let!(:keyword2) { create(:keyword, report: report, status: :failed) }
    let!(:keyword3) { create(:keyword, report: report, status: :pending) }

    before do
      report.update(status: :failed)
    end

    it 'test' do
      cmd = described_class.call(params)
      p cmd.result

      expect(cmd.success?).to be(true)
    end
  end
end
