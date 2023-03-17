class CreateKeywords < ActiveRecord::Migration[6.1]
  def change
    create_table :keywords do |t|
      t.string :value

      t.references :user, foreign_key: true
      t.references :report, foreign_key: true

      t.integer :ad_words_count
      t.integer :links_count

      t.bigint :total_results
      t.decimal :search_time, precision: 14, scale: 4

      t.text :html_string, :limit => 60_000

      t.timestamps
    end
  end
end
