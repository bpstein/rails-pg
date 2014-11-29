class AddListingIdToNotification < ActiveRecord::Migration
  def change
  	add_column :notifications,:listing_id,:integer 
  	change_column :notifications,:status,:string,:default=>"unread"
  	remove_column :notifications,:type
  	add_column :notifications,:approval_status,:string 
  end
end
