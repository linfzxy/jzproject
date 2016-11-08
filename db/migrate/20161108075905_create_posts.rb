class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :body
      t.text :url
      t.integer :lastpage
      t.string :mid

      t.timestamps
    end
  end
end
