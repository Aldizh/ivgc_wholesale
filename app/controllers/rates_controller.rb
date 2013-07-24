class RatesController < ApplicationController
  def index
  	@rates = Rate.all
  end
  def import
    Rate.import(params[:file])
	redirect_to rates_url, notice: "Rates imported."
  end
end
