require 'rails_helper'

RSpec.describe Api::V1::Authenticate::SignIn do
  let(:email) { 'jobs@tednguyen.me' }
  let(:password) { 'password123' }
  let(:user) { create(:user, email: email, password: password) }

  subject(:command) { described_class.new(email: email, password: password) }

  context 'when the email is incorrect' do
    let(:email) { 'invalid@tednguyen.me' }

    it 'fails' do
      expect(command.call.success?).to be false
    end

    it 'returns an error message in the response' do
      expect(command.call.result[:message]).to eq('The email address or password is incorrect.')
    end
  end

  context 'when the password is incorrect' do
    let(:password) { 'incorrect' }

    it 'fails' do
      expect(command.call.success?).to be false
    end

    it 'returns an error message in the response' do
      expect(command.call.result[:message]).to eq('The email address or password is incorrect.')
    end
  end

  context 'when the user is not activated' do
    before { user }

    it 'fails' do
      expect(command.call.success?).to be false
    end

    it 'returns an error message in the response' do
      expect(command.call.result[:message]).to eq('This account is not activated yet.')
    end
  end

  context 'when the email and password are correct & already activated' do
    before do
      user.update(activated: true)
    end

    it 'succeeds' do
      expect(command.call.success?).to be true
    end

    it 'returns a JWT token in the response data' do
      expect(command.call.result[:data][:token]).to be_a(String)
    end
  end
end
