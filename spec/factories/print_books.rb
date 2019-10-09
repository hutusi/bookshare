# frozen_string_literal: true

FactoryBot.define do
  factory :print_book do
    book
    association :owner, factory: :user
    association :holder, factory: :user
    property { 0 }
    status { 0 }
    images { "MyText" }
    description { "MyText" }
    association :creator, factory: :user
  end
end
