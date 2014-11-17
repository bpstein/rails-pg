class Order < ActiveRecord::Base
	validates :address, :city, :state, presence: true 

	belongs_to :listing
	belongs_to :buyer, class_name: "User"
	belongs_to :seller, class_name: "User"

	after_create :email_purchaser

	private

	def email_purchaser
		PurchaseMailer.purchase_receipt(self).deliver
	end

end
