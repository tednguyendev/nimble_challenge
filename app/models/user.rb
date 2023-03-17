class User < ApplicationRecord
  has_secure_password
  has_many :reports
  has_many :keywords

	validates :email, presence: true, uniqueness: true
end
