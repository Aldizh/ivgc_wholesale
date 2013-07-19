require 'mail'
class ContactUsController < ApplicationController
  def index
  end

  def contactUs
	to = "bhuten@gmail.com"
	session[:full_name] = params[:full_name]
	session[:email] = params[:email]
	session[:message] = params[:message]

	from = params[:email]
	full_name = params[:full_name]
	subject = "IVGC Web Contact: " + full_name
	message = params[:message]

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
	   		body "Sender Name: #{full_name} \n\nEmail: #{from} \n\nMessage: #{message}"
		end
	 	redirect_to '/contact_us/thanksForContacting'
	
		rescue Exception => e
	 		flash[:error] = "You message was not sent! Please try again!"
	 		redirect_to contact_us_path
		end
 	end 

 	def thanksForContacting
 		
 	end
 end
