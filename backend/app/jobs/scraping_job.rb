class ScrapingJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0, tags: ['scraping']


  def perform(*args)
    keyword_record = args[0]
    result = GoogleScraper.call(keyword_record.word)
    keyword_record.update_columns(result)
  end
end