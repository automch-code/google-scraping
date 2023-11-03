class ImportHistory < ApplicationRecord
  enum :status, %i(pending failed success)

  belongs_to :user
  has_one_attached :file
end
