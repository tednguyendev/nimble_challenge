require 'rails_helper'

RSpec.describe Api::V1::Reports::FetchKeyword do
  let(:report) { create(:report) }
  let(:keyword) { create(:keyword, value: "crawl api", report: report) }

  subject(:command) { described_class.new(keyword.id) }

  context 'when keyword is already processing' do
    let(:keyword) { create(:keyword, value: "crawl api", report: report, status: Keyword::SUCCESS) }

    it 'does not change status' do
      expect { command.call }.not_to change { keyword.reload.status }
    end
  end

  context 'when keyword is processing' do
    context 'fetch success all keywords' do
      let(:html_string) { File.open(Rails.root.join('spec', 'mocks', 'crawl_api_google.html'), 'r').read }

      before do
        allow(command).to receive(:get_page_source).and_return(html_string)
        allow(ReportMailer).to receive(:report_status).and_return(double(deliver_later: true))

        command.call
      end

      it 'keywords updated correctly' do
        expect(keyword.reload.ad_words_count).to eq(3)
        expect(keyword.reload.links_count).to eq(170)
        expect(keyword.reload.total_results).to eq(15000000)
        expect(keyword.reload.search_time).to eq(0.59)
        expect(keyword.reload.html_string).to eq(html_string)
        expect(keyword.reload.status).to eq("success")
      end

      it 'report percentage updated correctly' do
        expect(report.reload.percentage).to eq(100)
      end

      it 'report status updated correctly' do
        expect(report.reload.status).to eq(Report::SUCCESS)
      end

      it 'sends status success email' do
        expect(ReportMailer).to have_received(:report_status).with(report.id).once
      end
    end

    context 'being blocked' do
      let(:html_string) { File.open(Rails.root.join('spec', 'mocks', 'capcha.html'), 'r').read }

      before do
        allow(command).to receive(:get_page_source).and_return(html_string)
        allow(ReportMailer).to receive(:report_status).and_return(double(deliver_later: true))

        command.call
      end

      it 'keywords updated correctly' do
        expect(keyword.reload.ad_words_count).to be_nil
        expect(keyword.reload.links_count).to be_nil
        expect(keyword.reload.total_results).to be_nil
        expect(keyword.reload.search_time).to be_nil
        expect(keyword.reload.html_string).to be_nil
        expect(keyword.reload.status).to eq("failed")
      end

      it 'report percentage updated correctly' do
        expect(report.reload.percentage).to eq(100)
      end

      it 'report status updated correctly' do
        expect(report.reload.status).to eq(Report::FAILED)
      end

      it 'sends status success email' do
        expect(ReportMailer).to have_received(:report_status).with(report.id).once
      end
    end
  end
end
