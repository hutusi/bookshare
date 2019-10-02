FactoryBot.define do
  factory :print_book do
    book
    association :owner, factory: :user
    association :holder, factory: :user
    status { 0 }
    property { 0 }
    images { "MyText" }
    description { "MyText" }
    association :creator, factory: :user
  end
end
