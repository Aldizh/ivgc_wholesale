class ApplicationController < ActionController::Base
  protect_from_forgery
  def get_session
  	@url = "https://208.65.111.144/rest/Session/login/{'login':'soap-webpanel','password':'wsw@c@8am'}"
    @uri = URI.encode(@url.gsub!("'", '"'))
    @response = RestClient::Request.new(
      :method => :post,
      :url => @uri,
      :headers => { :accept => :json, :content_type => :json}).execute

    @result = ActiveSupport::JSON.decode(@response)
    return @result["session_id"]
  end
  
  def uriEncoder (uri)
    return URI.encode(uri.gsub!("'", '"'))
  end

end
