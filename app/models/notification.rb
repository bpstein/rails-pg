class Notification < ActiveRecord::Base
	belongs_to :sender, class_name: "User", primary_key: "sender_id"
    belongs_to :receiver, class_name: "User", primary_key: "receiver_id"
    belongs_to :listing
end
