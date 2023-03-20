require 'rails_helper'

RSpec.describe Api::V1::Authenticate::VerifyEmail do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }

  subject(:command) { described_class.new(token: token) }

  context 'when the token is not valid' do
    let(:token) { 'invalid_token' }

    it 'fails' do
      expect(command.call.success?).to be_falsey
    end

    it 'returns an error message' do
      expect(command.call.result[:message]).to eq('Token is not valid.')
    end
  end

  context 'when the account is already activated' do
    before { user.update(activated: true) }

    it 'fails' do
      expect(command.call.success?).to be_falsey
    end

    it 'returns an error message' do
      expect(command.call.result[:message]).to eq('This account is already activated.')
    end
  end

  context 'when the token is valid and the account is not activated' do
    it 'updates the account activation status' do
      expect { command.call }.to change { user.reload.activated }.from(false).to(true)
    end

    it 'returns a new JWT token in the response data' do
      expect(command.call.result[:data][:token]).to be_a(String)
    end
  end
end
