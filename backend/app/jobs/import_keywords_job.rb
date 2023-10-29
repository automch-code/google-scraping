class ImportKeywordsJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0, tags: ['import_keyword']

  def perform(*args)
    puts "Job is Working now"
  end
end