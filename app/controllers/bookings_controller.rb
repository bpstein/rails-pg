class BookingsController < ApplicationController
	
	def index
		@bookings = Booking.all
	end

	def show
	  @booking = Booking.find(params[:id])
  end
	
	def new
	  @booking = Booking.new
	end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    if params[:booking]
      @booking.update(bookings_params)
    end
      # redirect_to booking_path
  end

  def create
    @booking = Booking.new(bookings_params)
    if @booking.save
      flash[:notice] = "Booking has been created!"
      # redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to(root_path)
  end

private

  def bookings_params
    params.require(:booking).permit(:buyer_id, :listing_id, :start_date, :end_date)
  end
end