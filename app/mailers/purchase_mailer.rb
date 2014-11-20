class PurchaseMailer < ActionMailer::Base
	layout 'purchase_mailer'
	default from: "PeerGear Bookings <contact@peergear.io>"

	def purchase_receipt purchase
		@purchase = purchase
		mail to: purchase.buyer.email, subject: "Thanks for booking with PeerGear!"
	end

end 

class UserMailer < ActionMailer::Base
	layout 'user_mailer'
	default from: "PeerGear Bookings <contact@peergear.io>"

	def booking_notification purchase
		@user = booking.user
		@booking = booking
		@listing = listing
		mail to: @user.email, subject: "Someone is interested in borrowing your gear!"
	end

end 