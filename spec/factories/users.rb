FactoryBot.define do
  factory :user do
    name { "MyString" }
    birthdate { "2022-06-30" }
    points_cached { 100 }
    tier { "standard" }
  end
end
