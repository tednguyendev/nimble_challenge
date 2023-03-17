class Report < ApplicationRecord
  belongs_to :user
  has_many :keywords
  enum status: %i[pending failed success]

  before_create :set_name
  before_update :set_status

  private

  def set_name
    self.name = "Report at #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}" if self.new_record?
  end

  def set_status
    if percentage == 100
      self.status = :success
    end
  end
end
