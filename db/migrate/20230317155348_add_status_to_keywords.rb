class AddStatusToKeywords < ActiveRecord::Migration[6.1]
  def change
    add_column :keywords, :status, :integer, default: 0
  end
end
