# frozen_string_literal: true

FactoryBot.define do
  factory :deal do
    type { "" }
    print_book
    book_id { print_book.book_id }
    association :sponsor, factory: :user
    association :receiver, factory: :user
    location { "MyString" }
    status { 0 }
    started_at { "2019-10-01 19:50:20" }
    finished_at { "2019-10-10 19:50:20" }

    factory :sharing do
      type { "Sharing" }
    end

    factory :borrowing do
      type { "Borrowing" }
    end
  end
end
