FactoryBot.define do
  factory :user, class: 'User' do
    sequence(:username) { |n| "test_user_#{n}" }
    sequence(:email) { |n| "johndoe#{n}@gmail.com" }
    sequence(:password) { |n| "1234#{n}" }

    trait :invalid do
      username { nil }
      email { nil }
      password { nil }
    end
  end
end