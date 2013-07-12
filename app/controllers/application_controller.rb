require "active_merchant"
class ApplicationController < ActionController::Base
  protect_from_forgery

  def get_new_session
    @url = "https://208.65.111.144/rest/Session/login/{'login':'soap-webpanel','password':'wsw@c@8am'}"
    @result = apiRequest(@url)
    return @result["session_id"]
  end

  def get_session
  	begin
      return @@session_id
    rescue
      @@session_id = get_new_session
    end
    return @@session_id
  end
  
  def apiRequest(url)
    uri = uriEncoder(url)
    request = RestClient::Request.new(
      method: :post,
      url: uri,
      headers: { :accept => :json, :content_type => :json})
    response = request.execute
    return ActiveSupport::JSON.decode(response)
  end

  ###### HELPER METHODS ######

  def uriEncoder(uri)
    return URI.encode(uri.gsub!("'", '"'))
  end

  def validate_company_name(company_name)
    if company_name.length <= 41
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

end
