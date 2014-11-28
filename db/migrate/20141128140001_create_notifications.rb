class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.text :message
      t.integer :sender_id
      t.integer :receiver_id 
      t.timestamps
    end
  end
end
