class PurchaseMailer < ActionMailer::Base
	layout 'purchase_mailer'
	default from: "PeerGear Bookings <contact@peergear.io>"

	def purchase_receipt purchase
		@purchase = purchase
		mail to: purchase.email, subject: "Thanks for booking with PeerGear!"
	end

end 