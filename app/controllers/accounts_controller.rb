class AccountsController < ApplicationController
  def index
    if not session[:current_login]
      redirect_to "/sessions/new"
    end
  end

  def account_list
    if session[:current_login]
      @session_id = get_session
      @url = "https://208.65.111.144/rest/Account/get_account_list/{'session_id':'#{@session_id}'}/{'i_customer':'1552'}"
      @result = apiRequest(@url)
    else
      flash[:error] = " Please login to continue! "
      redirect_to root_path
    end
  end

  def updateAccount
    # in this method, I get the account info and pass the necessary to the forms where user see what current info they have
    # and then can change it there and pass to another method whether the request for update will be sent.

    if session[:current_login]
      @session_id = get_session
      @url = "https://208.65.111.144/rest/Account/get_account_info/{'session_id':'4f6b66fbcfb40016fadd8ac2fb965507'}/{'i_customer':'1552'}"
      @result = apiRequest(@url)
    else
      flash[:error] = "Please login to continue!"
      redirect_to root_path
    end
    @comp_name = @result["account_info"]["companyname"]
    @user_name = @result["account_info"]["login"]
    @comp_name = @result["account_info"]["companyname"]
    @e_mail = @result["account_info"]["subscriber_email"]
  end

  def doUpdate
    if not session[:current_login]
      flash[:error] = "Please login to continue!"
      return redirect_to root_path
    end
    @session_id = get_session
    @company_name = params[:company_name]
    @login = params[:username]
    @password = params[:password]
    @email = params[:email]

    if not validate_login(@login)
      flash[:error] = "Username cannot have fewer than 6 characters"
      return redirect_to "/accounts/updateAccount"
    elsif not validate_pw(@password)
      flash[:error] = "Password cannot have fewer than 6 characters"
      return redirect_to "/accounts/updateAccount"
    elsif not validate_email(@email)
      flash[:error] = "Email is not valid"
      return redirect_to "/accounts/updateAccount"
    end
    @url = "https://208.65.111.144/rest/Account/update_account/{'session_id':'#{@session_id}}/{'account_info':{'i_account':'877771'},'subscriber_email':'#{@email}','login':'#{@login}','password':'#{@password}'}}"
    @result = apiRequest(@url)
           
    if @result["i_account"].nil?
      flash[:error] = "Oops! Try again!"
      redirect_to "accounts/updateAccount"
    else 
      flash[:notice] = "You successfully updated your account infos"
      redirect_to root_path
    end
  end
  # HELPER METHOD

  def validate_login(login)
    if login.length() >= 6
      return true
    else 
      return false
    end
  end

  def validate_pw(pw)
    if pw.length() >= 6
      return true
    else 
      return false
    end
  end

  def validate_email(email)
    #We should validate the email with regex 
    # taken from http://railscasts.com/episodes/219-active-model?view=asciicast
    email_re = /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
    regex = email_re.match(email)
    if email.length() < 6 or regex.nil?
      return false
    else
      return true
    end
  end

end
