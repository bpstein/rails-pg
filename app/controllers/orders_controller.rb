class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def show 
    @order = Order.find(params[:id])
  end

  def sales
    @orders = Order.all.where(seller: current_user).order("created_at DESC")
  end

  def purchases
    @orders = Order.all.where(buyer: current_user).order("created_at DESC")
  end

  # GET /orders/new
  def new
    @order = Order.new
    @listing = Listing.find(params[:listing_id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @listing = Listing.find(params[:listing_id])
    @seller = @listing.user

    @order.listing_id = @listing.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller.id

    # Stripe.api_key =  ENV[:stripeKey]
    
    # token = params[:stripeToken]

    # begin
    #   charge = Stripe::Charge.create(:amount => (@listing.price * 100).floor,:currency => "usd",:card => token)
    #   flash[:notice] = "Thanks for ordering! The details of your order have been delivered to your registered email address."
    # rescue Stripe::CardError => e
    #   flash[:danger] = e.message
    # end

    # transfer = Stripe::Transfer.create(
    #   :amount => (@listing.price * 95).floor,
    #   :currency => "usd",
    #   :recipient => @seller.recipient
    #   )
   
  @payment = PayPal::SDK::REST::Payment.new({
    :intent => "sale",
    :payer => {
      :payment_method => "credit_card",
      :funding_instruments => [{
        :credit_card => {
          :type => params[:order][:checkout_attributes][:card_type],
          :number => params[:order][:checkout_attributes][:card_no],
          :expire_month => params[:order][:checkout_attributes][:expiry_mon],
          :expire_year => params[:order][:checkout_attributes][:expiry_yr],
          :cvv2 => params[:order][:checkout_attributes][:cvv],
          :first_name => params[:order][:checkout_attributes][:first_name],
          :last_name => params[:order][:checkout_attributes][:last_name],
          :billing_address => {
            :line1 => params[:order][:address],
            :city => params[:order][:city],
            :state => params[:order][:state],
            :postal_code => params[:order][:postal_code],
            :country_code => params[:order][:country_code] }}}]},
    :transactions => [{
      :item_list => {
        :items => [{
          :name => @listing.name,
          :sku => @listing.name,
          :price => sprintf('%.2f', @listing.price),#,_attributes
          :currency => "USD",
          :quantity => '1' }]},
      :amount => {
        :total => sprintf('%.2f', @listing.price), #* 100).floor,
        :currency => "USD" },
      :description => "This is the payment transaction description." }]})

    if @payment.create
      # Payment Id 

      @order.checkout_attributes = { :pay_id => @payment.id,  :status => @payment.state,:payment_time => @payment.create_time,:currency=>@payment.transactions[0].amount.currency }   
      @order.save
      
      respond_to do |format|
        if @order.save!
          flash[:notice] = "Thanks for ordering! The details of your order have been delivered to your registered email address."
          format.html { redirect_to root_url }
          format.json { render action: 'show', status: :created, location: @order }
        else
          @payment.error  # Error Hash
          flash[:error] = "#{@payment.error}.Something went wrong.Your order is not placed.Please check your details."
          format.html { render action: 'new' }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end 
    else
      respond_to do |format|
        @payment.error  # Error Hash
        flash[:error] = "#{@payment.error}.Something went wrong.Please check your details."
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end  


    end   
    
    # respond_to do |format|
    #   if @order.save
    #     flash[:notice] = "Thanks for ordering! The details of your order have been delivered to your registered email address."
    #     format.html { redirect_to root_url }
    #     format.json { render action: 'show', status: :created, location: @order }
    #   else
    #     flash[:error] = "Something went wrong.Please check your details."
    #     format.html { render action: 'new' }
    #     format.json { render json: @order.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:address, :city, :state,:postal_code,:country_code,checkout_attributes:[:first_name, :last_name, :card_no,:card_type,:cvv,:expiry_mon,:expiry_yr,:pay_id,:currency,:order_id,:status,:payment_time])
    end

  end