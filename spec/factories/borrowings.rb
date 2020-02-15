# frozen_string_literal: true

FactoryBot.define do
  factory :borrowing do
    print_book
    book_id { print_book.book_id }
    association :holder, factory: :user
    association :receiver, factory: :user
    form { 0 }
    status { 0 }
    started_at { "2019-10-01 19:50:20" }
    finished_at { "2019-10-10 19:50:20" }
  end
end
