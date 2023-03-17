class AddPercentageAndStatusToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :percentage, :integer, default: 0
    add_column :reports, :status, :integer, default: 0
  end
end
