class Keyword < ApplicationRecord
  validates :value, presence: true

  belongs_to :user
  belongs_to :report

  before_validation :set_user_id

  private

  def set_user_id
    self.user_id = report.user_id
  end
end
