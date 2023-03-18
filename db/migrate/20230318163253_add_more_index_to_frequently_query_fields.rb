class AddMoreIndexToFrequentlyQueryFields < ActiveRecord::Migration[6.1]
  def change
    add_index :keywords, :value
    add_index :keywords, :status

    add_index :reports, :name
    add_index :reports, :status
    add_index :reports, :percentage

    add_index :users, :email
    add_index :users, :activated
  end
end
