FactoryBot.define do
  factory :print_book do
    book_id { 1 }
    owner_id { 1 }
    holder_id { 1 }
    status { "MyString" }
    property { "MyString" }
    images { "MyText" }
    description { "MyText" }
    created_by { 1 }
  end
end
