FactoryBot.define do
  factory :client do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.unique.subscriber_number(length: 11) }
    date_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    type_industry { Faker::Company.type }
    user { nil }
  end

  factory :invalid_client, parent: :client do
    name { nil }
    phone { nil }
    date_birth { nil }
    type_industry { nil }
    user { nil }
  end
end
