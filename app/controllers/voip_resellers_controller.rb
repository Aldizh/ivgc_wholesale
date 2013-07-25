require 'mail'

class VoipResellersController < ApplicationController
  def index
  end
  def voipResellerSignUp

  	to = "bhuten@gmail.com"
	session[:first_name] = params[:first_name]
	session[:last_name] = params[:last_name]
	session[:email] = params[:email]
	session[:phone] = params[:phone]
	session[:comments] = params[:comments]

	from = params[:email]
	full_name = params[:first_name] + " " + params[:last_name]
	subject = "IVGC Reseller Sign Up from Website: " + full_name + " from " + params["country"]["country_name"]
	phone = params[:phone]
	country_name = params["country"]["country_name"]
	language = params[:language]
	business = params[:business]
	revenue = params[:revenue]
	comments = params[:comments]

	options = { :address              => "smtp.gmail.com",
	           :port                 => 587,
	           :domain               => 'ciaotelecom.net',
	           :user_name            => 'its.ciaotelecom@gmail.com',
	           :password             => 'Ci402013',
	           :authentication       => 'plain',
	           :enable_starttls_auto => true  }
	Mail.defaults do
		delivery_method :smtp, options
	end
	
	begin 
		Mail.deliver do
	   		to 'bhuten@gmail.com'
	   		from "#{from}"
	   		subject "#{subject}"
	   		#body "hi"
	   		body "Sender Name: #{full_name} \n\nEmail: #{from} \n\nPhone: #{phone} \n\nCountry: #{country_name} \n\nLanguage: #{language} \n\nBusiness: #{business} \n\nMonthly Revenue: #{revenue}  \n\nComments: #{comments}"
		end
 	redirect_to "/voip_resellers/thanksForSigningUp"

	rescue Exception => e
 		flash[:error] = "You message was not sent! Please try again!"
 		redirect_to voip_resellers_path
	end
 end 

 def thanksForSigningUp

 	@full_name = session[:first_name] + " " + session[:last_name]
 	
 end

end
