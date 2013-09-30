require 'mail'
class SignupsController < ApplicationController
  def index
  end

  def signUp
    @company_name = params[:company_name]
    @login = params[:username]
    @pw = params[:password]
    @ip1 = params[:ip1]
    @email = params[:email]
    @phone = params[:phone].gsub(/[^0-9]/, "")  # remove non-numeric characters
    @cc = params[:cc].gsub(/[^0-9]/, "")

    session[:company_name] = @company_name
    session[:ip1] = @ip1
    session[:username] = @login
    session[:password] = @pw
    session[:email] = @email
    session[:cc] = @cc
    session[:phone] = @phone
    session[:current_user_id] = @login

    # check if any errors will occurr when attempting to signup
    error = signup_error(@company_name, @ip1, @login, @pw, @email, @cc, @phone)
    if error.nil?

      to = "#{@email}"
      from = "#{@login}"
      subject = "IVGC Wholesale Sign up " + from
      message = "Thank you for signing up with us Mr/Miss " + "#{@login}"

      options = { :address              => "smtp.gmail.com",
                 :port                 => 587,
                 :domain               => 'ciaotelecom.net',
                 :user_name            => 'admin@ivgc.net',
                 :password             => 'SWIu4*aDo*D#oucl',
                 :authentication       => 'plain',
                 :enable_starttls_auto => true  }
      Mail.defaults do
        delivery_method :smtp, options
      end
      
      begin 
        Mail.deliver do
            attachments["logo.png"] = File.read('app/assets/images/ivgc_logo.png')
            to "#{to}"
            from "#{from}"
            subject "#{subject}"
            body "Account Login/Username: #{from} \n\nMessage: #{message}"
        end  
      rescue Exception => e
          flash[:error] = "Sorry, email notification failed to be delievred!"
          redirect_to "/accounts/signUp"    
      end

      activation_date = Time.new.strftime("%Y-%m-%d")
      @hash_pw = @pw + '1a'
      @url = "https://208.65.111.144/rest/Account/add_account/{'session_id':'#{get_session2}'}/{'account_info':{'i_customer':'1552','i_product':'1','product_name':'Ciao Premium CLI 15', 'activation_date':'#{activation_date}','id':'#{@ip1}','balance':'0','opening_balance':'0','login':'#{@login}','password':'#{@pw}','h323_password':'#{@hash_pw}','blocked':'N','companyname':'#{@company_name}','phone1':'#{@cc + @phone}' ,'subscriber_email':'#{@email}', 'billing_model':'1', 'credit_limit':'0'}}"
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

  ###### HELPER METHODS ######

  def signup_error(company_name, ip, login, pw, email, cc, phone)
    # first validate form fields
    if not validate_company_name(company_name)
      return 'Company name is too long (41 characters max)!'
    elsif not validate_ip(ip)
      return 'IP Invalid!'
    elsif not validate_login(login)
      return 'Username cannot have fewer than 6 characters'
    elsif not validate_pw(pw)
      return 'Password must have 6-16 characters'
    elsif not validate_email(email)
      return 'Email is not valid'
    elsif not validate_cc(cc)
      return 'Country code is not valid'
    elsif not validate_phone(phone)
      return 'Phone Number is not valid'
    elsif not verify_recaptcha
      return 'Your words do not match the ones in the recaptcha image!'
    end

    # if made it this far, form fields pass validation
    # validate that account can be made
    activation_date = Time.new.strftime("%Y-%m-%d")
    @hash_pw = @pw + '1a'
    @url = "https://208.65.111.144/rest/Account/validate_account_info/{'session_id':'#{get_session2}'}/{'account_info':{'i_customer':'1552','i_product':'1','activation_date':'#{activation_date}','id':'#{@ip1}','balance':'0','opening_balance':'0','login':'#{@login}','password':'#{@pw}', 'h323_password':'#{@hash_pw}','blocked':'Y', 'companyname':'#{@company_name}','phone1':'#{@cc + @phone}' ,'subscriber_email':'#{@email}', 'billing_model':'1', 'credit_limit':'0'}}"
    begin
      @result = apiRequest(@url)
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
        return 'Session error'
      else
        return 'Unknown error has occurred'   # shouldn't happen
      end
    end
  end

end