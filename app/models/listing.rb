class Listing < ActiveRecord::Base
	has_attached_file :image, :styles => { :medium => "200px", :thumb => "100x100>" }, :default_url => "/images/no_image.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates :name, :description, :start_date, :end_date, :address, :city, :postcode, :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates_attachment_presence :image

  belongs_to :user
  belongs_to :category
  has_many :orders
  has_many :users, through: :bookings
  has_many :notifications,:dependent => :destroy

  # after_create :email_seller

  private

	def email_seller
		ListingMailer.listing_receipt(self).deliver
	end
end
