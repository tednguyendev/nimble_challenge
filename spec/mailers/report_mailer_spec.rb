require 'rails_helper'

RSpec.describe ReportMailer, type: :mailer do
  describe '#report_status_success' do
    let(:report) { create(:report) }
    let(:report_id) { report.id }
    let(:mail) { described_class.report_status_success(report_id).deliver_now }

    context 'report is not found' do
      let(:report_id) { 123 }

      it 'does not send an email' do
        expect { mail }.not_to change(ActionMailer::Base.deliveries, :count)
      end
    end

    context 'report found' do
      it 'send an email' do
        expect { mail }.to change(ActionMailer::Base.deliveries, :count)
      end

      it 'send correctly' do
        expect(mail.subject).to eq('Your report scraping is done!')
        expect(mail.to).to eq([report.user.email])
      end
    end
  end

  describe '#report_status_fail' do
    let(:report) { create(:report) }
    let(:report_id) { report.id }
    let(:mail) { described_class.report_status_fail(report_id).deliver_now }

    context 'report is not found' do
      let(:report_id) { 123 }

      it 'does not send an email' do
        expect { mail }.not_to change(ActionMailer::Base.deliveries, :count)
      end
    end

    context 'report found' do
      it 'send an email' do
        expect { mail }.to change(ActionMailer::Base.deliveries, :count)
      end

      it 'send correctly' do
        expect(mail.subject).to eq('Your report scraping is failed.')
        expect(mail.to).to eq([report.user.email])
      end
    end
  end
end
