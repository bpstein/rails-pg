class HomeController < ApplicationController
  def search
  	 @listings = Listing.where("city =? or country =?",params[:search],params[:search])
     @search = params[:search]
  end
end
