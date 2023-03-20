FactoryBot.define do
  factory :report do
    association :user, factory: :user
  end
end
