FactoryBot.define do
  factory :claim do
    user { nil }
    reward { nil }
    description { "MyText" }

    after(:build) do |claim|
      claim.user_id ||= create(:user).id
      claim.reward_id ||= create(:reward).id
    end
  end
end
