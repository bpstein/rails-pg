class AddLocationToListing < ActiveRecord::Migration
  def change
    add_column :listings, :address, :string
    add_column :listings, :city, :string
    add_column :listings, :postcode, :string
    add_column :listings, :country, :string
  end
end
