class SessionsController < ApplicationController
  def new
    #look at new views
  end

   def create
    login = params[:username]
    pw = params[:password]

    session_id = get_session
    url = "https://208.65.111.144/rest/Account/get_account_info/{'session_id':'#{session_id}'}/{'i_customer':'1552','login':'#{login}'}"
    result = apiRequest(url)

    if !result.empty? and (pw == result["account_info"]["password"])
      reset_session
      @@session_id = session_id
      session[:current_login] = login
      session[:current_pw] = pw
      session[:i_account] = result["account_info"]["i_account"]
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