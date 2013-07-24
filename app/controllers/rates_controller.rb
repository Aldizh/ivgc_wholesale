class RatesController < ApplicationController
  def index
  end
  def import
    Product.import(params[:file])
	redirect_to root_url, notice: "Rates imported."
  end
end
