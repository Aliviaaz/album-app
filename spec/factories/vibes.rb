FactoryBot.define do
  factory :vibe do
    # vibes.name has a unique index, so always sequence it
    sequence(:name) { |n| "Vibe #{n}" }
  end
end
