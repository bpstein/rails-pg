class AddStatusToNotification < ActiveRecord::Migration
  def change
  	add_column :notifications,:status,:string 
  	add_column :notifications,:type,:string
  end
end
