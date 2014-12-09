class Order < ActiveRecord::Base
	validates :address, :city, :state,:country_code,:postal_code, presence: true 

	belongs_to :listing
	belongs_to :buyer, class_name: "User"
	belongs_to :seller, class_name: "User"
    has_one :checkout 
    accepts_nested_attributes_for :checkout, :allow_destroy => true
	after_create :email_purchaser

	private

	def email_purchaser
		PurchaseMailer.purchase_receipt(self).deliver
	end

end
