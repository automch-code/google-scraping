class ScrapingJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 0, tags: ['scraping']

  def perform(*args)
    keyword_record = args[0]
    begin
      result = GoogleScraper.call(keyword_record.word)
      keyword_record.update(result)
    rescue Faraday::Error => e
      keyword_record.update(status: :failed)
    end
  end
end