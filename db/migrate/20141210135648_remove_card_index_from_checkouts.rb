class RemoveCardIndexFromCheckouts < ActiveRecord::Migration
  def change
  	remove_index(:checkouts, :name => 'index_checkouts_on_card_no')
  end
end
