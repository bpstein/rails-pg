class Booking < ActiveRecord::Base
  validates :end_date, :start_date, presence: :true
  belongs_to :user
  belongs_to :listing

  after_create :booking_message

  def booking_message
  	UserMailer.booking_confirmation(self).deliver
  end
end
