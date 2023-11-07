class Keyword < ApplicationRecord
  enum :status, %i(pending failed success)

  belongs_to :user

  after_save :update_result

  private

  def update_result
    ScrapingJob.perform_later(self)
  end
end
