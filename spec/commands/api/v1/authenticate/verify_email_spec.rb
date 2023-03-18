require 'rails_helper'

RSpec.describe Api::V1::Authenticate::VerifyEmail, type: :model do
  describe '#call' do
    let(:user) { create(:user) }

    context 'invalid token?' do
      let(:params) { { token: 'a' } }

      it 'fails' do
        cmd = described_class.call(params)

        expect(cmd.success?).to be(false)
      end
    end

    context 'expired token?' do
      let(:params) do
        {
          token: JsonWebToken.encode({user_id: user.id}, 1.days.ago)
        }
      end

      it 'fails' do
        cmd = described_class.call(params)
        # pp "========>cmd.errors : ", cmd.errors, cmd.result

        expect(cmd.success?).to be(false)
      end
    end

    context 'activated account?' do
      let(:params) do
        {
          token: JsonWebToken.encode(user_id: user.id)
        }
      end

      before do
        user.update(activated: true)
      end

      it 'fails' do
        cmd = described_class.call(params)

        expect(cmd.success?).to be(false)
      end
    end

    context 'valid token?' do
      let(:params) do
        {
          token: JsonWebToken.encode(user_id: user.id)
        }
      end

      it 'success' do
        cmd = described_class.call(params)

        expect(cmd.success?).to be(true)
      end
    end
  end
end
