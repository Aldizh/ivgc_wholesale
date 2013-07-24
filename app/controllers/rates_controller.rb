class RatesController < ApplicationController
  def index
  end
  def import
  	CSV.foreach(params[:file].path, headers: true) do |row|
	    rate = Rate.find_by_country(row["country"]) || Rate.new
	    rate.attributes = row.to_hash.slice(*Rate.accessible_attributes)
	    rate.save!
  	end
	redirect_to rates_url, notice: "Rates imported."
  end
  def displayRate 
  	@rates = Rate.all
  	render :layout => false
  end
end
