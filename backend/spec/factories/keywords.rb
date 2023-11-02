FactoryBot.define do
  factory :keyword do
    sequence(:word)                  { |n| "word#{n}" }
  end
end