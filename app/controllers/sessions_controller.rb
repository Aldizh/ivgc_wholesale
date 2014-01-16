class SessionsController < ApplicationController
  def new
    #look at new views
  end

   def create
    login = params[:username]
    pw = params[:password]
    begin
      url = "https://208.65.111.144/rest/Customer/get_customer_info/{'session_id':'#{get_session2}'}/{'login':'#{login}'}"
      result = apiRequest(url)
      session[:admin] = false
      if !result.empty? and (pw == result["customer_info"]["password"])
        reset_session
        session[:i_customer] = result["customer_info"]["i_customer"]
        session[:customer_login] = result["customer_info"]["login"]
        session[:current_pw] = pw

        url_list = "https://208.65.111.144/rest/Account/get_account_list/{'session_id':'#{get_session2}'}/{'i_customer':'#{session[:i_customer]}'}"
        result_list = apiRequest(url_list)

        url_next = "https://208.65.111.144/rest/Account/get_account_info/{'session_id':'#{get_session2}'}/{'i_account':'#{result_list["account_list"][0]["i_account"]}'}"
        result_next = apiRequest(url_next)

        puts result_next["account_info"].inspect
        session[:current_login] = result["customer_info"]["login"]
        session[:i_account] = result_next["account_info"]["i_account"]
        session[:email] = result_next["account_info"]["subscriber_email"]
        if result_next['account_info']['login'] == 'aldizhup'
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
    destroy_session2_id
    @@admin = false
    reset_session
    flash[:notice] = "You are successfuly logged out!"
    redirect_to '/sessions/new'
  end

end