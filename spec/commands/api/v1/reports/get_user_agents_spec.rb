require 'rails_helper'

RSpec.describe Api::V1::Reports::GetUserAgents do
  subject(:command) { described_class.new() }

  it 'returns correct agents' do
    expect(command.call.result.length).to eq(1000)
  end
end
