FactoryBot.define do
  factory :artist do
    sequence(:name) { |n| "Artist #{n}" }
    is_group { false }

    trait :group do
      is_group { true }
    end
  end
end
