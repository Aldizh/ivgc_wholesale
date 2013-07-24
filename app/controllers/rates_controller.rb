class RatesController < ApplicationController
  def index
  end
  def import
  	CSV.foreach(params[:file].path, headers: true) do |row|
	    rate = Rate.find_by_id(row["id"]) || Rate.new
	    if not rate
	    	rate.attributes = row.to_hash.slice(*Rate.accessible_attributes)
	    	rate.save!
	    end
  	end
	redirect_to rates_url, notice: "Rates imported."
  end
  def displayRate 
  	@rates = Rate.all
  	render :layout => false
  end
end
