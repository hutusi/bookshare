FactoryBot.define do
  factory :deal do
    type { "" }
    print_book_id { 1 }
    sponsor_id { 1 }
    receiver_id { 1 }
    location { "MyString" }
    status { "MyString" }
    started_at { "2019-10-01 19:50:20" }
    finished_at { "2019-10-01 19:50:20" }
  end
end
