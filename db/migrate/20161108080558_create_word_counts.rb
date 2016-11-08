class CreateWordCounts < ActiveRecord::Migration[5.0]
  def change
    create_table :word_counts do |t|
      t.string :word
      t.integer :count

      t.timestamps
    end
  end
end
