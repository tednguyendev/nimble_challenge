# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) } # Use FactoryBot to create a new user object for each test

  describe 'validations' do
    context 'with invalid attributes' do
      describe 'email' do
        context 'without an email' do
          it 'is not valid' do
            user.email = nil
            expect(user).not_to be_valid
          end
        end

        context 'with an invalid email format' do
          it 'is not valid' do
            user.email = 'invalidemail'
            expect(user).not_to be_valid
          end
        end

        context 'with a duplicate email' do
          before { create(:user, email: 'test@example.com') } # Create a user with a specific email address

          it 'is not valid' do
            user.email = 'test@example.com'
            expect(user).not_to be_valid
          end
        end
      end

      describe 'password' do
        context 'without a password' do
          it 'is not valid' do
            user.password = nil
            expect(user).not_to be_valid
          end
        end

        context 'with a short password' do
          it 'is not valid' do
            user.password = '1234567' # Less than the 8 character minimum
            expect(user).not_to be_valid
          end
        end
      end
    end

    context 'with valid attributes' do
      it 'is valid' do
        expect(user).to be_valid
      end
    end
  end

  describe 'associations' do
    it { should have_many(:reports).dependent(:destroy) }
    it { should have_many(:keywords).dependent(:destroy) }
  end
end
