class Booking < ActiveRecord::Base
  belongs_to :user
  belongs_to :listing

  after_create :booking_message

  def booking_message
  	UserMailer.booking_confirmation(self).deliver
  end
end
