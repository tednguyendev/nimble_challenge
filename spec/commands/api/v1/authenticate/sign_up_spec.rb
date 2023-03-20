require 'rails_helper'

RSpec.describe Api::V1::Authenticate::SignUp do
  let(:email) { 'jobs@tednguyen.me' }
  let(:password) { 'password123' }

  subject(:command) { described_class.new(email: email, password: password) }

  context 'the email is already taken' do
    let!(:user) { create(:user, email: email, password: password) }

    it 'fails' do
      expect { command.call }.not_to change(User, :count)
    end

    it 'returns an error message' do
      expect(command.call.result[:message]).to eq('The email address is already exists.')
    end
  end

  context 'the email is not taken' do
    context 'the params are invalid' do
      let(:email) { 'invalid-email' }

      it 'fails' do
        expect { command.call }.not_to change(User, :count)
      end

      it 'returns an error message' do
        expect(command.call.result[:message]).to eq('Parameters are invalid!')
      end
    end

    context 'the params are valid' do
      it 'creates a new user' do
        expect { command.call }.to change(User, :count).by(1)
      end

      it 'sends a welcome email' do
        allow(UserMailer).to receive(:welcome).and_return(double(deliver_later: true))

        command.call

        expect(UserMailer).to have_received(:welcome).with(User.last.id)
      end
    end
  end
end
