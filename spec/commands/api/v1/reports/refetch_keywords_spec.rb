require 'rails_helper'

RSpec.describe Api::V1::Reports::RefetchKeywords, type: :model do
  describe '#call' do
    let(:params) do
      {
        id: report_id,
        current_user: user
      }
    end

    let(:user) { create(:user) }
    let(:report) { create(:report, name: 'b', user: user) }
    let(:report_id) { report.id }

    let!(:keyword1) { create(:keyword, report: report, status: Keyword::SUCCESS) }
    let!(:keyword2) { create(:keyword, report: report, status: Keyword::FAILED) }
    let!(:keyword3) { create(:keyword, report: report, status: Keyword::PENDING) }

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
      before do
        report.update(status: Report::FAILED)
      end

      it 'succeeds' do
        expect(command.call.success?).to be true
      end

      it 'update record correctly' do
        expect { command.call }.to change { report.reload.status }.from('failed').to(Report::PENDING)
      end

      it 'not update keywords1' do
        expect { command.call }.not_to change { keyword1.reload.status }
      end

      it 'update keywords2 correctly' do
        expect { command.call }.to change { keyword2.reload.status }.from('failed').to(Report::PENDING)
      end

      it 'not update keywords3' do
        expect { command.call }.not_to change { keyword3.reload.status }
      end

      it 'enqueues a background job to fetch keywords' do
        expect {
          command.call
        }.to change(FetchKeywordsWorker.jobs, :size).by(1)
      end
    end
  end
end
