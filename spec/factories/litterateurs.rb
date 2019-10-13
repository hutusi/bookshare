# frozen_string_literal: true

FactoryBot.define do
  factory :litterateur do
    name { "MyString" }
    country { "MyString" }
    gender { 1 }
    image { "MyString" }
    birthdate { "2019-10-13 11:37:23" }
    deathdate { "2019-10-13 11:37:23" }
    bio { "MyText" }
    intro { "MyText" }
    origin_name { "MyString" }
    pen_name { "MyString" }
  end
end
