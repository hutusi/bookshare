# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "person#{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
    password { "123456" }
    password_confirmation { "123456" }
    sequence(:api_token) { |n| "api_token_#{n}" }
  end
end
