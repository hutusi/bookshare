# frozen_string_literal: true

FactoryBot.define do
  factory :series do
    name { "MyString" }
    douban_id { 1 }
    intro { "MyText" }
  end
end
