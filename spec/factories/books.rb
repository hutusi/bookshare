FactoryBot.define do
  factory :book do
    title { "MyString" }
    subtitle { "MyString" }
    author { "MyString" }
    publisher { "MyString" }
    intro { "MyText" }
    isbn { "MyString" }
    cover_url { "MyString" }
    douban_id { "MyString" }
    association :creator, factory: :user
  end
end
