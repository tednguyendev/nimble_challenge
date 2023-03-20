class User < ApplicationRecord
  has_secure_password
  has_many :reports, dependent: :destroy
  has_many :keywords, dependent: :destroy

	validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, :if => :password_digest_changed?
end
