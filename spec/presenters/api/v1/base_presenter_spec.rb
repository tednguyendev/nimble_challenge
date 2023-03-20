require 'rails_helper'

RSpec.describe Api::V1::BasePresenter do
  let(:user) { create(:user, email: 'john@example.com', password: 'password123') }
  let(:params) {}

  describe '.json' do
    context 'the params is a collection' do
      let(:params) { [user] }

      it 'returns an array of objects' do
        json_output = described_class.json(params)

        expect(json_output).to be_an_instance_of(Array)
      end

      it 'returns correct data' do
        json_output = described_class.json(params)

        expect(json_output.length).to eq(1)
        expect(json_output.first['id']).to eq(user.id)
        expect(json_output.first['email']).to eq(user.email)
      end
    end

    context 'the params is an object' do
      let(:params) { user }

      it 'returns an a object' do
        json_output = described_class.json(params)

        expect(json_output).to be_an_instance_of(Hash)
      end

      it 'returns correct data' do
        json_output = described_class.json(params)

        expect(json_output['id']).to eq(user.id)
        expect(json_output['email']).to eq(user.email)
      end
    end
  end
end
