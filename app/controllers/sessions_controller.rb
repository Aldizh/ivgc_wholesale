class SessionsController < ApplicationController
  def new
    #look at new views
  end

   def create
    login = params[:username]
    pw = params[:password]
    begin
      url = "https://208.65.111.144/rest/Account/get_account_info/{'session_id':'#{get_session2}'}/{'i_customer':'1552','login':'#{login}'}"
      result = apiRequest(url)
    @@admin = false
    session[:admin] = false
    if !result.empty? and (pw == result["account_info"]["password"])
      reset_session
      session[:current_login] = login
      session[:current_pw] = pw
      session[:i_account] = result["account_info"]["i_account"]
      if result['account_info']['login'] == 'wesley123456'
        @@admin = true
        session[:admin] = true
        flash[:notice] = "You are now logged in as an admin!"
        return redirect_to '/admin/index'
      end
    end

    if session[:current_login]
      flash[:notice] = "You are successfuly logged in!"
      redirect_to '/accounts'
    else 
      flash[:error] = "Wrong Login or Password!"
      redirect_to '/sessions/new'
    end
    rescue RuntimeError
      flash[:error] = "Password and login can't be empty!"
      redirect_to new_session_path
    end
  end

  def destroy
    destroy_session_id
    @@admin = false
    reset_session
    flash[:notice] = "You are successfuly logged out!"
    redirect_to '/sessions/new'
  end

end