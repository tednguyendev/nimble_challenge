require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '#welcome' do
    let(:user) { create(:user) }
    let(:user_id) { user.id }
    let(:mail) { described_class.welcome(user_id).deliver_now }

    context 'when user is not found' do
      let(:user_id) { 123 }

      it 'does not send an email' do
        expect { mail }.not_to change(ActionMailer::Base.deliveries, :count)
      end
    end

    context 'when user found' do
      it 'send an email' do
        expect { mail }.to change(ActionMailer::Base.deliveries, :count)
      end

      it 'send correctly' do
        expect(mail.subject).to eq('Welcome to Nimble Web Scraper Service! 👋🏻')
        expect(mail.to).to eq([user.email])
      end
    end
  end
end
