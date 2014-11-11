class AddPlaceToListings < ActiveRecord::Migration
  def change
  	add_column :listings, :place, :string, :null=>false
  end
end
