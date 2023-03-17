class Keyword < ApplicationRecord
  enum status: %i[pending failed success]
  validates :value, presence: true

  belongs_to :user
  belongs_to :report

  before_validation :set_user_id
  after_update :update_report_percentage

  private

  def set_user_id
    self.user_id = report.user_id
  end

  def update_report_percentage
    keywords_count = report.keywords.count
    success_keywords_count = report.keywords.where(status: 'success').count

    percentage = (success_keywords_count.to_f / keywords_count) * 100

    report.update(percentage: percentage)
  end
end
