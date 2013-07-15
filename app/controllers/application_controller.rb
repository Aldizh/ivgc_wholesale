require "active_merchant"
class ApplicationController < ActionController::Base
  protect_from_forgery


  def get_new_session
    url = "https://208.65.111.144:8444/rest/Session/login/{'login':'ivgc','password':'wsw@c@8am'}"
    @result = apiRequest(url)
    return @result["session_id"]
  end

  # higher privileged session
  def get_new_session2
    url = "https://208.65.111.144/rest/Session/login/{'login':'soap-webpanel','password':'wsw@c@8am'}"
    @result = apiRequest(url)
    return @result["session_id"]
  end

  # manage session_id by keeping track of whether @@session_id_privileged was ever set.
  # if it was set to true and requesting lower privileged, it resets it to nil, 
  #   sets @@session_id_privileged correctly, and sets the @@session_id correctly
  def get_session
    # privileged = true only if get_session2 was called previously
    privileged = @@session_id_privileged rescue false
    # if the current @@session_id is privileged, then reset it
    if privileged
      destroy_session2_id   # attempts to log out of the higher privileged session
      @@session_id_privileged = false
    end
    begin
      # if @@session_id already exists and is not nil, return @@session_id
      if not @@session_id.nil?
        return @@session_id
      else
        # @@session_id is nil, so set it again
        @@session_id = get_new_session
      end
    # rescue @@session_id if it has never been set and set it
    rescue
      @@session_id = get_new_session
    end
    # returns the @@session_id, which occurrs only if it was never set
    return @@session_id
  end
  

  # higher privileged session
  # same idea as get_session
  def get_session2
    privileged = @@session_id_privileged rescue false
    if !privileged
      @@session_id = nil
      @@session_id_privileged = true
    end
    begin
      if not @@session_id.nil?
        return @@session_id
      else
        @@session_id = get_new_session2
      end
    rescue
      @@session_id = get_new_session2
    end
    return @@session_id
  end

  def destroy_session_id
    @@session_id = nil
  end

  # logout of privileged session
  def destroy_session2_id
    url = "https://208.65.111.144/rest/Session/logout/{'session_id':'#{get_session2}'}"
    begin
      apiRequest(url)
    rescue RestClient::InternalServerError => e
      error_message = e.response[e.response.index('faultstring')+14..-3]
      if error_message != "Session id is expired or doesn't exist"
        puts "Something went wrong trying to logout"
      end
    end
    @@session_id = nil
  end

  def apiRequest(url)
    puts "@@@@ API REQUEST@@@@@@@@@@@@@@"
    puts url.gsub("'", '"')
    uri = uriEncoder(url)
    request = RestClient::Request.new(
      method: :post,
      url: uri,
      headers: { :accept => :json, :content_type => :json})
    begin
      puts "@@@@@ API RESPONSE @@@@"
      response = request.execute
      puts ActiveSupport::JSON.decode(response)
      return ActiveSupport::JSON.decode(response)
    rescue Exception => e
      puts "@@@@@ API RESCUE @@@@@"
      raise e.inspect
    end
    #return ActiveSupport::JSON.decode(response)
  end

def validateLoggedIn
    if not session[:current_login]
      flash[:error] = "Please login to continue!"
      return redirect_to "/sessions/new"
    end
  end

  ###### HELPER METHODS ######

  def uriEncoder(uri)
    return URI.encode(uri.gsub!("'", '"'))
  end

  def validate_company_name(company_name)
    if company_name.length() <= 41
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

  def validate_phone(phone)
    if phone.length() == 10
      return true
    else 
      return false
    end
  end

  def validate_full_phone(phone)
    if phone.length() > 13 or phone.length() < 11
      return false
    else
      return true
    end
  end

  def validate_name(name)
    if name.length() > 120
      return false
    else
      return true
    end
  end

end
