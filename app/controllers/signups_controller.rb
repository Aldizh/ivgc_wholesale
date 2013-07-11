class SignupsController < ApplicationController
  def index
    @@session_id = get_session
  end

  def signUp
    @company_name = params[:company_name]
    @login = params[:username]
    @pw = params[:password]
    @ip1 = params[:ip1]
    @email = params[:email]
    @phone = params[:phone]
    @cc = params[:cc]

    session[:company_name] = @company_name
    session[:username] = @login
    session[:ip1] = @ip1
    session[:email] = @email
    session[:phone] = @phone
    session[:cc] = @cc
    session[:session_id] = @@session_id
    session[:current_user_id] = @login
    session[:password] = @pw

    if not validate_ip(@ip1)
      flash[:error] = "IP Invalid!"
      return redirect_to signups_path
    elsif not validate_login(@login)
      flash[:error] = "Username cannot have fewer than 6 characters"
      return redirect_to signups_path
    elsif not validate_pw(@pw)
      flash[:error] = "Password must have 6-16 characters"
      return redirect_to signups_path
    elsif not validate_email(@email)
      flash[:error] = "Email is not valid"
      return redirect_to signups_path
    elsif not validate_cc(@cc)
      flash[:error] = "Country code is not valid"
      return redirect_to signups_path
    elsif not validate_phone(@phone)
      flash[:error] = "Phone Number is not valid"
      return redirect_to signups_path
    elsif not verify_recaptcha
      flash[:error] = "Your words do not match the ones in the recaptcha image!"
      return redirect_to signups_path
    end
    @full_phone = @cc + @phone
    error = signup_error    # check if any errors will occurr when attempting to signup
    if error.nil?
      @url = "https://208.65.111.144/rest/Account/add_account/{'session_id':'#{@@session_id}'}/{'account_info':{'i_customer':'1552','i_product':'1','activation_date':'2009-2-23','id':'#{@ip1}','balance':'0','opening_balance':'0','login':'#{@login}','password':'#{@pw}','blocked':'Y', 'companyname':'#{@company_name}','phone1':'#{@full_phone}' ,'subscriber_email':'#{@email}'}}"
      @result = apiRequest(@url)
      session[:current_login] = @login
      session[:i_account] = @result["i_account"]
      flash[:notice] =  "Sign up successful!"
      redirect_to "/accounts/addCredits"
    else
      flash[:error] = error
      redirect_to signups_path
    end

  end

  ###### HELPER METHOFS ######
  def signup_error
    url = "https://208.65.111.144/rest/Account/validate_account_info/{'session_id':'#{@@session_id}'}/{'account_info':{'i_customer':'1552','i_product':'1','activation_date':'2009-2-23','id':'#{@ip1}','balance':'0','opening_balance':'0','login':'#{@login}','password':'#{@pw}','blocked':'Y', 'companyname':'#{@company_name}','phone1':'#{@full_phone}' ,'subscriber_email':'#{@email}'}}"
    begin
      @result = apiRequest(url)
      return  # no errors
    rescue RestClient::InternalServerError => e
      # get the error message given from api
      error_message = e.response[e.response.index('faultstring')+14..-3]
      case error_message
      when 'Duplicate account id within environment'
        return 'IP already exists'
      when 'Duplicate account login'
        return 'Username already exists'
      when 'Authentification failed'
        return 'Internal server error'  # invalid session id
      when 'Auth info missed' #due to session id being empty
        @@session_id = get_session
        return signup_error
      else
        return 'Unknown error has occurred'   # shouldn't happen
      end
    end
  end


  #URI enencoder helper method
  def uriEncoder (uri)
    return URI.encode(uri.gsub("'", '"'))
  end

  # Validation helper method
  def validate_login(login)
    if login.length() >= 6
      return true
    else 
      return false
    end
  end

  def validate_ip(ip)
    begin
      ip_array = ip.split('.').map {|i| i.to_i}
    rescue
      return false
    end
    if ip_array.length != 4
      return false
    end
    ip_array.each do |i|
      if i > 255 or i < 0
        return false
      end
    end
    return true
  end

  def validate_pw(pw)
    if pw.length() >= 6 and pw.length() <= 16
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

  def validate_phone(phone)
    #We should validate the email with regex 
    if phone.length() == 10
      return true
    else 
      return false
    end
  end

  def validate_cc(cc)
    begin
      number = cc.to_i
    rescue
      return false
    end
    if number < 1 or number > 999
      return false
    end
    return true
  end

end