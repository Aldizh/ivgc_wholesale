class AccountsController < ApplicationController
  def index
  end

  def account_list
  	#@id = Rails.cache.read(id)
    if session[:current_user_id]
      @url = "https://208.65.111.144:8444/rest/Account/get_account_list/%7B%22session_id%22:%22377edf68679d89c0c2fd8dd098721778%22%7D/%7B%22offset%22:%2220%22,%20%22i_customer%22:%221552%22%7D"
      @response = RestClient::Request.new(
        :method => :post,
        :url => @url,
        :headers => { :accept => :json, :content_type => :json}).execute
      @result = ActiveSupport::JSON.decode(@response)
    else
      flash[:error] = " Please login to continue! "
      redirect_to root_path
    end
  end

end
