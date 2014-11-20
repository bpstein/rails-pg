class ListingMailer < ActionMailer::Base
	layout 'listing_mailer'
	default from: "PeerGear Bookings <contact@peergear.io>"

	def listing_receipt listing
		@listing = listing
		mail to: listing.seller.email, subject: "Thanks for listing your items with PeerGear!"
	end

end 