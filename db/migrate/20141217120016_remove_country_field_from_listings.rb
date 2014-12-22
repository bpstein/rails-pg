class RemoveCountryFieldFromListings < ActiveRecord::Migration
  def change
  	remove_column :listings,:country
  end
end
