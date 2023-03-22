require 'rails_helper'

RSpec.describe Api::V1::Reports::FetchKeywords do
  let(:report) { create(:report, status: Report::PENDING) }
  let(:keyword1) { create(:keyword, value: "crawl api", report: report) }
  let(:keyword2) { create(:keyword, value: "how can i build a house", report: report) }

  subject(:command) { described_class.new(report.id) }

  context 'when report is already finished' do
    let(:report) { create(:report, status: Report::SUCCESS) }

    it 'does not change status' do
      expect { command.call }.not_to change { report.reload.status }
    end

    it 'does not change percentage' do
      expect { command.call }.not_to change { report.reload.percentage }
    end
  end

  context 'when report is pending' do
    context 'fetch success all keywords' do
      let(:html_string1) { File.open(Rails.root.join('spec', 'mocks', 'crawl_api_google.html'), 'r').read }
      let(:html_string2) { File.open(Rails.root.join('spec', 'mocks', 'how_can_i_build_a_house_google.html'), 'r').read }

      before do
        allow(command).to receive(:get_page_source).with(keyword1).and_return(html_string1)
        allow(command).to receive(:get_page_source).with(keyword2).and_return(html_string2)

        command.call
      end

      it 'keywords updated correctly' do
        expect(keyword1.reload.ad_words_count).to eq(3)
        expect(keyword1.reload.links_count).to eq(170)
        expect(keyword1.reload.total_results).to eq(15000000)
        expect(keyword1.reload.search_time).to eq(0.59)
        expect(keyword1.reload.html_string).to eq(html_string1)
        expect(keyword1.reload.status).to eq("success")

        expect(keyword2.reload.ad_words_count).to eq(0)
        expect(keyword2.reload.links_count).to eq(170)
        expect(keyword2.reload.total_results).to be_nil
        expect(keyword2.reload.search_time).to be_nil
        expect(keyword2.reload.html_string).to eq(html_string2)
        expect(keyword2.reload.status).to eq("success")
      end

      it 'report updated correctly' do
        expect(report.reload.status).to eq("success")
        expect(report.reload.percentage).to eq(100)
      end

      it 'sends report status success mail' do
        expect(ReportMailer).to receive(:report_status_success).with(report.id).and_call_original
        command.send(:send_report_status_success)
      end
    end

    context 'being blocked' do
      let(:html_string1) { File.open(Rails.root.join('spec', 'mocks', 'capcha.html'), 'r').read }
      let(:html_string2) { File.open(Rails.root.join('spec', 'mocks', 'how_can_i_build_a_house_google.html'), 'r').read }

      before do
        allow(command).to receive(:get_page_source).with(keyword1).and_return(html_string1)
        allow(command).to receive(:get_page_source).with(keyword2).and_return(html_string2)

        command.call
      end

      it 'keywords updated correctly' do
        expect(keyword1.reload.ad_words_count).to be_nil
        expect(keyword1.reload.links_count).to be_nil
        expect(keyword1.reload.total_results).to be_nil
        expect(keyword1.reload.search_time).to be_nil
        expect(keyword1.reload.html_string).to be_nil
        expect(keyword1.reload.status).to eq("failed")

        expect(keyword2.reload.ad_words_count).to be_nil
        expect(keyword2.reload.links_count).to be_nil
        expect(keyword2.reload.total_results).to be_nil
        expect(keyword2.reload.search_time).to be_nil
        expect(keyword2.reload.html_string).to be_nil
        expect(keyword2.reload.status).to eq(Keyword::PENDING)
      end

      it 'report updated correctly' do
        expect(report.reload.status).to eq("failed")
        expect(report.reload.percentage).to eq(0)
      end
      it 'sends report status fail mail' do
        expect(ReportMailer).to receive(:report_status_fail).with(report.id).and_call_original
        command.send(:send_report_status_fail)
      end
    end
  end
end
