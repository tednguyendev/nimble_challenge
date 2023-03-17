class Report < ApplicationRecord
  belongs_to :user

  before_create :set_name

  private

  def set_name
    self.name = "Report at #{Time.current.strftime('%Y-%m-%d %H:%M:%S')}" if self.new_record?
  end
end
