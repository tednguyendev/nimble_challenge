class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.string :name, default: ''
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
