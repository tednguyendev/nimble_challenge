require 'rails_helper'

RSpec.describe Api::V1::Reports::Get, type: :model do
  describe '#call' do
    let(:params) do
      {
        id: report1.id,
        current_user: user
      }
    end

    let!(:user) { create(:user) }
    let!(:report1) { create(:report, name: 'b', user: user) }

    let!(:keyword1) { create(:keyword, value: 'a', report: report1) }
    let!(:keyword2) { create(:keyword, value: 'b', report: report1) }
    let!(:keyword3) { create(:keyword, value: 'c', report: report1) }

    it 'test' do
      cmd = described_class.call(params)
      p cmd.result

      expect(cmd.success?).to be(true)
    end
  end
end
