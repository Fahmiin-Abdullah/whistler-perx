FactoryBot.define do
  factory :points_record do
    user { nil }
    transaction { nil }
    amount { 1 }
    description { "MyText" }
    action { "credit" }
  end
end
