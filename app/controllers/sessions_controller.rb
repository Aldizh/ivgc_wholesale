class SessionsController < ApplicationController
  def new
  	#look at new views
  	if session[:current_user_id]
      redirect_to '/accounts'
    end
  end

  def create
    @login = params[:username]
    @pw = params[:password]

    @session_id = get_session

    @url = "https://208.65.111.144/rest/Account/get_account_list/{'session_id':'#{@session_id}'}/{'i_customer':'1552'}"
    @uri = uriEncoder(@url)
    puts @uri

    @response = RestClient::Request.new(
      :method => :post,
      :url => @uri,
      :headers => { :accept => :json, :content_type => :json}).execute
    @result = ActiveSupport::JSON.decode(@response)

    @result["account_list"].each do |account|
      puts account["password"]
      if account["login"] == @login
        if account["password"] == @pw
          session[:current_login] = @login
          session[:current_pw] = @pw
        end
      end
    end

    if session[:current_login]
      flash[:notice] = "You are successfuly logged in!"
      redirect_to '/accounts'
    else 
      flash[:error] = "Wrong Login or Password!"
      redirect_to '/sessions/new'
    end

  end

  def destroy
    reset_session
    flash[:notice] = "You are successfuly logged out!"
    redirect_to '/sessions/new'
  end
  	
end
