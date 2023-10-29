class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :confirmable, :database_authenticatable, :recoverable, :validatable
  
  has_many  :access_tokens,
          class_name: 'Doorkeeper::AccessToken',
          foreign_key: :resource_owner_id,
          dependent: :delete_all
  has_many  :import_histories
  has_many  :keywords

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :email, uniqueness: { case_sensitive: false }
  validates :email, length: { maximum: 255 }

  enum role: %i[user admin]

  def self.authenticate(email, password)
    user = User.find_for_authentication(email:)
    user&.valid_password?(password) && user&.active_for_authentication? ? user : nil
  end
end
