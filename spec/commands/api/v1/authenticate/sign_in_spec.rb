require 'rails_helper'

RSpec.describe Api::V1::Authenticate::SignIn, type: :model do
  describe '#call' do
    let(:email) { 'ted@gmail.com' }
    let(:password) { 'password123' }
    let(:activated) { true }
    let(:invalid_password) { 'password' }
    let(:params) do
      {
        email: email,
        password: password
      }
    end

    before do
      create(
        :user,
        email: email,
        password: password,
        activated: activated,
      )
    end

    context 'invalid login info?' do
      let(:params) do
        {
          email: email,
          password: invalid_password
        }
      end

      it 'fails' do
        cmd = described_class.call(params)
        # pp "========>cmd.errors : ", cmd.errors, cmd.result

        expect(cmd.success?).to be(false)
      end
    end

    context 'user not actived yet?' do
      let(:activated) { false }

      it 'fails' do
        cmd = described_class.call(params)
        # pp "========>cmd.errors : ", cmd.errors, cmd.result


        expect(cmd.success?).to be(false)
      end
    end

    context 'valid info?' do
      it 'success' do
        cmd = described_class.call(params)
        pp "========>cmd.errors : ", cmd.errors, cmd.result

        expect(cmd.success?).to be(true)
      end
    end
  end
end
