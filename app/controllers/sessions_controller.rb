class SessionsController < ApplicationController
  def new
  	#look at new views
  	if session[:current_user_id]
      redirect_to '/accounts'
    end
  end

  def create
  	account = Account.authenticate(params[:username], params[:password])

  	if account
      session[:session_id] = get_session
      session[:current_user_id] = account["login"]
      session[:password] = account["password"]
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
