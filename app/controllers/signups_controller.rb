class SignupsController < ApplicationController
  def index
  	@url = "https://208.65.111.144/rest/Session/login/{'login':'soap-webpanel','password':'wsw@c@8am'}"
  	@uri = uriEncoder(@url)
    @response = RestClient::Request.new(
      :method => :post,
      :url => @uri,
      :headers => { :accept => :json, :content_type => :json}).execute

    @result = ActiveSupport::JSON.decode(@response)

    @@session_id = @result["session_id"]
    session[:session_id] = @result["session_id"]
  end

  def signUp
  	@id = params[:username]
    @pw = params[:password]

    if validate(@id, @pwd)
	    @url = "https://208.65.111.144/rest/Account/add_account/{'session_id':'#{@@session_id}'}/{'account_info':{'i_customer':'1552','i_product':'1','activation_date':'2009-2-23','id':'#{@id}','balance':'0','opening_balance':'0','login':'#{@id}','h323_password':'#{@pw}','blocked':'Y'}}"
	    @uri = uriEncoder(@url)
	    @response = RestClient::Request.new(
	      :method => :post,
	      :url => @uri,
	      :headers => { :accept => :json, :content_type => :json}).execute

	    @result = ActiveSupport::JSON.decode(@response)
	  else 
  	  flash[:error] = "Your username and password cannot have fewer than 6 characters."
  	  redirect_to "/"
	end
  end

  #URI enencoder helper method
  def uriEncoder (uri)
    return URI.encode(uri.gsub!("'", '"'))
  end

  def validate(id,pw)
  	if id.length() >= 6 and pw.length >= 6
  		return true
  	else 
  		return false
  	end
  end

end
