class AddFieldsToOrder < ActiveRecord::Migration
  def change
  	add_column :orders,:postal_code,:string 
  	add_column :orders,:country_code,:string 
  end
end
