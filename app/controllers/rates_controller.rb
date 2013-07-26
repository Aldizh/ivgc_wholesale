class RatesController < ApplicationController
  def index
  end
  def import
  	CSV.foreach(params[:file].path, headers: true) do |row|
	    rate = Rate.find_by_destination(row["destination"]) || Rate.new
	    rate.attributes = row.to_hash.slice(*Rate.accessible_attributes)
	    rate.save!
  	end
	redirect_to rates_url, notice: "Rates imported."
  end
  def displayRate 
  	@rates = Rate.all
    puts "DJHDJHJKDHJDHKJDHJKHDJKHJKAHJKHJKHJKHJKHJKHJKHJKHJKHJKHJKHJK***D(*U*((*D(&*&*(&987897897897897"
    puts @rates.inspect
  	render :layout => false
  end
end
