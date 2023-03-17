FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "jobs#{n}+1@tednguyen.me"
    end
    password { 'password123' }
  end
end
