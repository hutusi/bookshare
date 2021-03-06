# frozen_string_literal: true

FactoryBot.define do
  factory :identity do
    user
    provider { "wechat" }
    sequence(:uid) { |n| "uid-#{n}" }
  end
end
