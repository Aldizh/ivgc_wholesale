class SignupsController < ApplicationController
  @@session_id = ''
  def index
    @url = "https://208.65.111.144/rest/Session/login/{'login':'soap-webpanel','password':'wsw@c@8am'}"
    @uri = URI.encode(@url.gsub!("'", '"'))
    @response = RestClient::Request.new(
      :method => :post,
      :url => @uri,
      :headers => { :accept => :json, :content_type => :json}).execute

    @result = ActiveSupport::JSON.decode(@response)
    @@session_id = @result["session_id"]
  end

  def signUp
    @company_name = params[:company_name]
  	@id = params[:username]
    @pw = params[:password]
    @email = params[:email]
    @phone = params[:phone]

    session[:company_name] = @company_name
    session[:username] = @id
    session[:email] = @email
    session[:phone] = @phone
    session[:session_id] = @@session_id
    session[:current_user_id] = @id
    session[:password] = @pw
    if validate_id(@id)
      if validate_pw(@pw)
        if validate_email(@email)
          if validate_phone(@phone)
            if verify_recaptcha
  	          @url = "https://208.65.111.144/rest/Account/add_account/{'session_id':'#{@@session_id}'}/{'account_info':{'i_customer':'1552','i_product':'1','activation_date':'2009-2-23','id':'#{@id}','balance':'0','opening_balance':'0','login':'#{@id}','password':'#{@pw}','blocked':'Y', 'companyname':'#{@company_name}','phone1':'#{@phone}' ,'subscriber_email':'#{@email}'}}"
  	          @uri = uriEncoder(@url)
  	          begin 
                @response = RestClient::Request.new(
                  :method => :post,
                  :url => @uri,
                  :headers => { :accept => :json, :content_type => :json}).execute
                @result = ActiveSupport::JSON.decode(@response)
                redirect_to "/accounts", notice: "Sign up successful!"
              rescue RestClient::InternalServerError
                flash[:error] = "Sorry, this user name already exists"
                redirect_to signups_path
              end
            else
               flash[:error] = "Your words do not match the ones in the recaptcha image!"
               redirect_to signups_path
            end
          else
            flash[:error] = "Phone Number is not valid"
            redirect_to signups_path
          end
        else
          flash[:error] = "Email is not valid"
          redirect_to signups_path
        end
      else 
        flash[:error] = "Password cannot have fewer than 6 characters"
        redirect_to signups_path
      end
	  else 
  	  flash[:error] = "Username cannot have fewer than 6 characters"
  	  redirect_to signups_path
	  end
  end

  ###### HELPER METHOFS ######

  #URI enencoder helper method
  def uriEncoder (uri)
    return URI.encode(uri.gsub!("'", '"'))
  end

  # Validation helper method
  def validate_id(id)
  	if id.length() >= 6
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

  def validate_phone(phone)
    #We should validate the email with regex 
    if phone.length() == 10
      return true
    else 
      return false
    end
  end

end
