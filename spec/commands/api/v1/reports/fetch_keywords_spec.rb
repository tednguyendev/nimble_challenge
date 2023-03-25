require 'rails_helper'

RSpec.describe Api::V1::Reports::FetchKeywords do
  subject(:command) { described_class.new(report.id) }

  describe '#perform' do
    let(:report) { create(:report) }
    let!(:keyword1) { create(:keyword, report: report) }
    let!(:keyword2) { create(:keyword, report: report) }

    context 'when report success is false' do
      it 'enqueues background job to fetch keywords' do
        expect {
          command.call
        }.to change(FetchKeywordWorker.jobs, :size).by(2)
      end
    end

    context 'when report status is success' do
      before do
        report.update(status: Report::SUCCESS)
      end

      it 'not enqueues background job to fetch keywords' do
        expect {
          command.call
        }.not_to change(FetchKeywordWorker.jobs, :size)
      end
    end
  end
end
