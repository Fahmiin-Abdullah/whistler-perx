FactoryBot.define do
  factory :transaction do
    user_id { nil }
    currency { "MyString" }
    amount { "9.99" }
    description { "MyText" }

    after(:build) do |transaction|
      transaction.user_id ||= create(:user).id
    end
  end
end
