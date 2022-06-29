FactoryBot.define do
  factory :feedback do
    project_name { "MyString" }
    description { "Lorem ipsum dolor sit amet consectetur adipisicing elit. Porro mollitia qui tenetur facilis vero laborum. Necessitatibus minima ipsam quaerat voluptas incidunt voluptate pariatur aperiam accusamus itaque eius. Consequatur, nulla laboriosam! Lorem ipsum dolor sit amet consectetur adipisicing elit. Porro mollitia qui tenetur facilis vero laborum. Necessitatibus minima ipsam quaerat voluptas incidunt voluptate pariatur aperiam accusamus itaque eius. Consequatur, nulla laboriosam!" }
    link_project { "MyString" }
    testimoni { "Lorem ipsum dolor sit amet consectetur adipisicing elit. Porro mollitia qui tenetur facilis vero laborum. Necessitatibus minima ipsam quaerat voluptas incidunt voluptate pariatur aperiam accusamus itaque eius. Consequatur, nulla laboriosam!" }
    rating { 1 }
    freelancer { nil }
    user { nil }
  end

  factory :invalid_feedback, parent: :feedback do
    project_name { nil }
    description { nil }
    link_project { nil }
    testimoni { nil }
    rating { 1 }
    freelancer { nil }
    user { nil }
  end
end
