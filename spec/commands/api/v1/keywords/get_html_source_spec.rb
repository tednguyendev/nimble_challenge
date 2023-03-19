require 'rails_helper'

RSpec.describe Api::V1::Keywords::GetHtmlSource, type: :model do
  describe '#call' do
    let(:params) do
      {
        id: keyword1.id,
        current_user: user
      }
    end

    let!(:user) { create(:user) }
    let!(:report1) { create(:report, user: user) }
    let(:html_string) { '<html><body><h1>Test</h1></body></html>' }
    let!(:keyword1) { create(:keyword, value: 'a', html_string: html_string, report: report1) }

    it 'test' do
      cmd = described_class.call(params)
      p cmd.result

      expect(cmd.success?).to be(true)
    end
  end
end
