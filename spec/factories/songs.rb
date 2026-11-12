FactoryBot.define do
  factory :song do
    sequence(:name) { |n| "Song #{n}" }
    is_favorite { false }
    album

    trait :favorite do
      is_favorite { true }
    end
  end
end
