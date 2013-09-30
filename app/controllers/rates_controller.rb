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
  	#@rates = Rate.all
    @url = "https://208.65.111.144/rest/Rate/get_rate_list/{'session_id':'#{get_session2}'}/{'i_tariff':'966', 'effective_from':'now', 'limit':'100'}"
    @result = apiRequest(@url)
    if params[:first_letter] and params[:first_letter] != '*'
      url_all = "https://208.65.111.144/rest/Rate/get_rate_list/{'session_id':'#{get_session2}'}/{'i_tariff':'966', 'effective_from':'now'}"
      result_all = apiRequest(url_all)
      all_rates = result_all['rate_list']
      @rates = []
      all_rates.each do |r|
        if r['country'].start_with?("#{params[:first_letter]}")
          @rates.push(r)
        end
      end
      render :layout => false
    elsif params[:first_letter] == '*'
      url_all = "https://208.65.111.144/rest/Rate/get_rate_list/{'session_id':'#{get_session2}'}/{'i_tariff':'72', 'effective_from':'now'}"
      result = apiRequest(url_all)
      @rates = result['rate_list']
      render :layout => false
    else
      @rates = @result['rate_list']
  	  render :layout => false
    end
  end
end
