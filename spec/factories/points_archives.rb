FactoryBot.define do
  factory :points_archive do
    user { nil }
    year { "MyString" }
    total { 1 }

    after(:build) do |archive|
      archive.user_id ||= create(:user).id
    end
  end
end
