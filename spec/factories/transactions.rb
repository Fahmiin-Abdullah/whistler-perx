FactoryBot.define do
  factory :transaction do
    user { nil }
    currency { "MyString" }
    amount { "9.99" }
    description { "MyText" }
  end
end
