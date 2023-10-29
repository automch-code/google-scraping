FactoryBot.define do
  factory :import_history do
    sequence(:filename)               { |n| "keywords_#{n}.csv" }
  end
end