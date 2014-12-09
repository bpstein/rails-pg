class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.string :pay_id,null: false 
      t.string :status
      t.string :card_type,null: false 
      t.string :card_no,:limit=>16,null: false 
      t.integer :cvv,:limit=>3,null: false
      t.integer :expiry_mon,:limit=>2,null: false 
      t.integer :expiry_yr,:limit=>4,null: false 
      t.string :first_name
      t.string :last_name
      t.string :currency,null: false
      t.datetime :payment_time,null: false
      t.references :order
      t.timestamps
    end
     add_index :checkouts, :pay_id,unique: true
     add_index :checkouts, :card_no,unique: true

    end
  end
