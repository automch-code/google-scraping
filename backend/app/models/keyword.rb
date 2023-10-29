class Keyword < ApplicationRecord
  belongs_to :user
  has_one_attached :html_file
end
