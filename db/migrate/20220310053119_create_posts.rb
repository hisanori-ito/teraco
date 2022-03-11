class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      
      t.integer :user_id, null: false
      t.string :title, null: false
      t.string :thumbnail
      t.string :video
      t.text :content, null: false

      t.timestamps
    end
  end
end
