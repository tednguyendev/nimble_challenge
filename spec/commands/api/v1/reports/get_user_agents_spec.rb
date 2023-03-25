require 'rails_helper'

RSpec.describe Api::V1::Reports::GetUserAgents do
  it 'returns a random user agent string' do
    user_agent = described_class.instance.random_user_agent
    expect(described_class.instance.user_agents).to include(user_agent)
  end
end
