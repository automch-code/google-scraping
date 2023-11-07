class Keyword < ApplicationRecord
  enum :status, %i(pending failed success)

  belongs_to :user

  after_save :update_result

  private

  def update_result
    result = GoogleScraper.call(self.word)
    self.update_columns(result)
  end
end
