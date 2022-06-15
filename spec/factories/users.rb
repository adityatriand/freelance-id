FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    role { 1 }
  end

  factory :invalid_user, parent: :user do
    email { nil }
    password { nil }
    role { '10s' }
  end

end
