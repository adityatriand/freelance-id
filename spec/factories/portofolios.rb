FactoryBot.define do
  factory :portofolio do
    title { "MyString" }
    description { "MyString" }
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
