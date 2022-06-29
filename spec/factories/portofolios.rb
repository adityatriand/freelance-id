FactoryBot.define do
  factory :portofolio do
    title { "MyString" }
    description { "Lorem ipsum dolor sit amet consectetur adipisicing elit. Porro mollitia qui tenetur facilis vero laborum. Necessitatibus minima ipsam quaerat voluptas incidunt voluptate pariatur aperiam accusamus itaque eius. Consequatur, nulla laboriosam! Lorem ipsum dolor sit amet consectetur adipisicing elit. Porro mollitia qui tenetur facilis vero laborum. Necessitatibus minima ipsam quaerat voluptas incidunt voluptate pariatur aperiam accusamus itaque eius. Consequatur, nulla laboriosam!" }
    type_project { "MyString" }
    client_name { "MyString" }
    client_industry { "MyString" }
    link_url { "MyString" }
    porto_attachment { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 'spec/fixtures/test.jpg')))}
    user { nil }
  end

  factory :invalid_portofolio, parent: :portofolio do
    title { nil }
    description { nil }
    type_project { nil }
    client_name { nil }
    client_industry { nil }
    link_url { nil }
    porto_attachment { nil }
    user { nil }
  end
end
