class RatesController < ApplicationController
  def index
  	@rates = Rate.all
  end
  def import
  	spreadsheet = Rate.import(params[:file])
  	header = spreadsheet.row(1)
  	(2..spreadsheet.last_row).each do |i|
	    row = Hash[[header, spreadsheet.row(i)].transpose]
	    product = find_by_id(row["id"]) || new
	    product.attributes = row.to_hash.slice(*accessible_attributes)
	    product.save!
  	end
	redirect_to rates_url, notice: "Rates imported."
  end
end
