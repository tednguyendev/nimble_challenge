require 'rails_helper'

RSpec.describe Keyword, type: :model do
  let(:user) { create(:user) }
  let(:report) { create(:report, user: user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:report) }
  end

  describe 'validations' do
    it { should validate_presence_of(:value) }
  end

  describe 'callbacks' do
    describe 'set_user_id' do
      context 'a new keyword is created' do
        let(:keyword) { create(:keyword, report: report) }

        it 'sets the user ID to the report user ID' do
          expect(keyword.user_id).to eq(user.id)
        end
      end
    end
  end

  describe 'scopes' do
    describe 'order_by_created_at_ascending' do
      let!(:older_keyword) { create(:keyword, report: report, created_at: 1.day.ago) }
      let!(:newer_keyword) { create(:keyword, report: report, created_at: Time.zone.now) }

      it 'orders the keywords by created_at in ascending order' do
        expect(Keyword.order_by_created_at_ascending).to eq([older_keyword, newer_keyword])
      end
    end
  end
end
