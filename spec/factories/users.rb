FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { "123456789" }
    password_confirmation { "123456789" }
    confirmed_at { Time.current }

    transient do
      questions_count { 5 }
      awards_count { 5 }
    end

    factory :user_with_questions do
      after(:create) do |user, evaluator|
        create_list(:question, evaluator.questions_count, author: user)
      end
    end

    factory :user_with_awards do
      after(:create) do |user, evaluator|
        create_list(:award, evaluator.awards_count, user: user)
      end
    end
  end
end
