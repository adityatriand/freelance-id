FactoryBot.define do
  factory :freelancer do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.unique.subscriber_number(length: 11) }
    date_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    category_work { Faker::Job.field }
    user { nil }
  end

  factory :invalid_freelancer, parent: :freelancer do
    name { nil }
    phone { nil }
    date_birth { nil }
    category_work { nil }
    user { nil }
  end
end
