class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true

  has_many :listings, dependent: :destroy, through: :bookings
  has_many :sales, class_name: "Order", foreign_key: "seller_id"
  has_many :purchases, class_name: "Order", foreign_key: "buyer_id"
  has_many :sent_notifications, class_name: "Notification", foreign_key: "sender_id"
  has_many :received_notifications, class_name: "Notification", foreign_key: "receiver_id"
  after_create :send_welcome_message

  def send_welcome_message
  	UserMailer.signup_confirmation(self).deliver
  end

  def is_owner?(user)
    self.id == user.id
  end  

end
