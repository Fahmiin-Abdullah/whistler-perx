FactoryBot.define do
  factory :points_record do
    user_id { nil }
    transaction_id { nil }
    amount { 1 }
    description { "MyText" }
    action { "credit" }

    after(:build) do |points_record|
      points_record.user_id ||= create(:user).id
      points_record.transaction_id ||= create(:transaction).id
    end
  end
end
