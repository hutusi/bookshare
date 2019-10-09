# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { "MyString" }
    subtitle { "MyString" }
    author { "MyString" }
    publisher { "MyString" }
    intro { "MyText" }
    sequence(:isbn) { |n| "isbn#{n}" }
    cover { "MyString" }
    sequence(:douban_id) { |n| "douban_id#{n}" }
    association :creator, factory: :user
  end
end
