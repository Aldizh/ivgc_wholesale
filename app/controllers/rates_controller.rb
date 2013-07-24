class RatesController < ApplicationController
  def index
  end
  def import
    Rate.import(params[:file])
	redirect_to rates_url, notice: "Rates imported."
  end
  def displayRate 
  	@rates = Rate.all
  	render :layout => false
  end
end
