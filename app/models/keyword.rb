class Keyword < ApplicationRecord
  validates :value, presence: true

  belongs_to :user
  belongs_to :report
end
