class Keyword < ApplicationRecord
  enum :status, %i(pending failed success)

  belongs_to :user

  after_commit :scrape_google_page,   on: :create

  private

  def scrape_google_page
    ScrapingJob.set(wait: rand(60).seconds).perform_later(self)
  end
end
