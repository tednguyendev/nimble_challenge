class Report < ApplicationRecord
  belongs_to :user
  has_many :keywords
  enum status: %i[pending failed success]

  before_create :set_name
  before_update :set_status

  scope :order_by_name_descending, -> { order(name: :desc) }
  scope :order_by_name_ascending, -> { order(name: :asc) }
  scope :order_by_created_at_descending, -> { order(created_at: :desc) }
  scope :order_by_created_at_ascending, -> { order(created_at: :asc) }

  private

  def set_name
    self.name = "Report at #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}" if self.new_record? && self.name.blank?
  end

  def set_status
    if percentage == 100
      self.status = :success
    end
  end
end
