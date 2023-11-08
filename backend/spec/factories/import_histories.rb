FactoryBot.define do
  factory :import_history do
    sequence(:filename)               { |n| "keywords_#{n}.csv" }
    file                              { Rack::Test::UploadedFile.new(fixture_file_path('cat_keyword.csv')) }
    status                            { :pending }
  end
end