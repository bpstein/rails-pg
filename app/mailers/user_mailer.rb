class UserMailer < ActionMailer::Base
	layout 'user_mailer'
	default from: "PeerGear Bookings <contact@peergear.io>"

	def signup_confirmation(user)
		@user = user
		mail to: @user.email, subject: "Thanks for signing up with PeerGear!"
	end

	def booking_confirmation(booking)
		@user = booking.user
		@booking = booking
		@listing = listing
		mail to: @user.email, subject: "Thanks for listing your items with PeerGear!"
	end

	def borrowing_notification listing
		@user = listing.user
		@listing = listing
		mail to: @user.email, subject: "Someone is interested in borrowing your gear!"
	end


end 