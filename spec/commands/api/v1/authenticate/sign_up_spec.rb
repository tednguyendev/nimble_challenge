require 'rails_helper'

RSpec.describe Api::V1::Authenticate::SignUp, type: :model do
  describe '#call' do
    let(:email) { 'ted@gmail.com' }
    let(:params) do
      {
        email: email,
        password: 'password123',
      }
    end

    context 'email already exist?' do
      before do
        create(:user, email: email)
      end

      it 'fails' do
        cmd = described_class.call(params)

        expect(cmd.success?).to be(false)
      end
    end

    context 'email not exist?' do
      context 'invalid params?' do
        let(:params) { {} }

        it 'fails' do
          cmd = described_class.call(params)

          expect(cmd.success?).to be(false)
        end
      end

      context 'create success?' do
        it 'success' do
          cmd = described_class.call(params)

          expect(cmd.success?).to be(true)
        end
      end
    end
  end
end
