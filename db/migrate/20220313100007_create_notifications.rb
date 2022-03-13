class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :from_user_id, null: false
      t.integer :to_user_id, null: false
      t.integer :post_id
      t.integer :comment_id
      t.string :action, default: '', null: false
      t.boolean :checked, default: false, null: false

      t.timestamps
    end
    
    add_index :notifications, :from_user_id
    add_index :notifications, :to_user_id
    add_index :notifications, :post_id
    add_index :notifications, :comment_id
  end
end
