require 'database_cleaner'

RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner[:active_record].strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  rescue StandardError => e
    p e
  end

  config.after(:all) do
    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end
end
