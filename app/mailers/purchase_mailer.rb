class PurchaseMailer < ActionMailer::Base
	layout 'purchase_mailer'
	default from: "PeerGear Bookings <contact@peergear.io>"

	def purchase_receipt purchase
		@purchase = purchase
		Rails.logger.debug '*******'
		Rails.logger.debug purchase.inspect
		mail to: purchase.buyer.email, subject: "Thanks for booking with PeerGear!"
	end

end 