class User < ApplicationRecord
  has_secure_password
  has_many :reports
  has_many :keywords

	validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }
end
