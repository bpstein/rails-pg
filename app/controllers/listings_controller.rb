class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :set_listing_notify,only: [:send_notification,:accept_request,:reject_request]
  before_action :set_notification, only: [:accept_request,:reject_request]
  before_filter :authenticate_user!, only: [:new, :seller, :create, :edit, :update, :destroy]
  before_filter :check_user, only: [:edit, :update, :destroy]

  def seller
    # @listings = Listing.where(user: current_user).order("created_at DESC")
    @reservation_listings = Listing.joins(:notifications).where("notifications.receiver_id=? and user_id=? and notifications.approval_status=?",current_user.id,current_user.id,"accepted")
    # @listing_notifications = current_user.sent_notifications.where("approval_status =?","accepted")
    @notifications = current_user.received_notifications.where("status =?","unread")
    @pending_listings = Listing.joins(:notifications).where("notifications.receiver_id=? and user_id=? and notifications.status=?",current_user.id,current_user.id,"unread").select('listings.*,notifications.id as notification_id')
    # if @notifications
    #   @pending_gears = @notifications.map(&:listing)
    # end 
  end

  # GET /listings
  # GET /listings.json
  def index
    if params[:category].blank?
      @listings = Listing.all.order("created_at DESC")
    else
      @category_id = Category.find_by(name: params[:category]).id
      @listings = Listing.where(category_id: @category_id).order("created_at DESC")
    end
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    
    @notification = Notification.find_by_sender_id_and_listing_id(current_user.id,@listing.id)
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(listing_params)
    @listing.user_id = current_user.id

    # if current_user.recipient.blank?
    #   Stripe.api_key = ENV["STRIPE_API_KEY"]
    #   token = params[:stripeToken]

      # recipient = Stripe::Recipient.create(
      #   :name => current_user.name,
      #   :type => "individual",
      #   :bank_account => token
      #   )
      
    #   current_user.recipient = recipient.id
    #   current_user.save
    # end

    

    respond_to do |format|
      if @listing.save
        format.html { redirect_to @listing, notice: 'Listing was successfully created.' }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # def remove_notification
  #   @notification = Notification.find(params[:notification_id])
  #   @notification.destroy
  #   redirect_to seller_path
  # end 

  def send_notification
    @sender = current_user
    @receiver = @listing.user
    @notification = Notification.find_by_sender_id_and_listing_id(@sender.id,@listing.id)
    unless @sender.id == @receiver.id && @notification
      UserMailer.borrowing_notification(@listing) 
      @notification = Notification.create(:message=>"#{@sender.name} is interested in borrowing your gears",:sender_id=>@sender.id,:receiver_id=>@receiver.id,:listing_id=>@listing.id)
      respond_to do |format|
        format.js
      end
    end 
  end 

  def accept_request
    @notification.update_attributes(:status=>"read",:approval_status=>"accepted",:message=>"#{@sender.name} has accepted your request for borrowing your gears name")
    # @new_notification = Notification.create(:message=>"#{@sender.name} has accepted your request for borrowing your gears name #{@listing.name}",:sender_id=>@sender.id,:receiver_id=>@receiver,:listing_id=>params[:listing_id],:approval_status=>"accepted")
    UserMailer.accepted_request_for_gear(@notification)
    redirect_to seller_path
  end
  
  def reject_request
    @notification.update_attributes(:status=>"read",:approval_status=>"rejected",:message=>"#{@sender.name} has rejected your request for borrowing your gears name")
    # @new_notification = Notification.create(:message=>"#{@sender.name} has rejected your request for borrowing your gears name #{@listing.name}",:sender_id=>@sender.id,:receiver_id=>@receiver.id,:listing_id=>params[:listing_id],:approval_status=>"rejected")
    UserMailer.rejected_request_for_gear(@otification)
    redirect_to seller_path
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end
    
    def set_notification
     @notification = Notification.find(params[:notification_id])
      @sender = current_user
      @receiver = @notification.sender_id
    end

    def set_listing_notify
      @listing = Listing.find(params[:listing_id])
    end  
    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(:name, :category_id, :description, :address, :city, :postcode, :price, :image,:start_date,:end_date)
    end
    
    def check_user
      if current_user != @listing.user
        redirect_to root_url, alert: "Sorry, this listing belongs to someone else"
      end
    end
end
