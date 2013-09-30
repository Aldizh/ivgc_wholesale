require 'mail'
class ContactUsController < ApplicationController
  def index
  end

  def contactUs
	if validate_email(params[:email])
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
		           :user_name            => 'admin@ivgc.net',
		           :password             => 'SWIu4*aDo*D#oucl',
		           :authentication       => 'plain',
		           :enable_starttls_auto => true  }
		Mail.defaults do
			delivery_method :smtp, options
		end
		if I18n.locale == :en
			begin 
				Mail.deliver do
					attachments["logo.png"] = File.read('app/assets/images/ivgc_logo.png')
			   		to 'sales@ivgc.net'
			   		from "#{from}"
			   		subject "#{subject}"
			   		body "Sender Name: #{full_name} \n\nEmail: #{from} \n\nMessage: #{message}"
				end
				Mail.deliver do
					attachments["logo.png"] = File.read('app/assets/images/ivgc_logo.png')
			   		to 'andrew@ciaotelecom.com'
			   		from "#{from}"
			   		subject "#{subject}"
			   		body "Sender Name: #{full_name} \n\nEmail: #{from} \n\nMessage: #{message}"
				end
			 	redirect_to '/contact_us/thanksForContacting'
			
			rescue Exception => e
			 		flash[:error] = "You message was not sent! Please try again!"
			 		redirect_to contact_us_path
			end
		else
			begin 
				Mail.deliver do
					attachments["logo.png"] = File.read('app/assets/images/ivgc_logo.png')
			   		to 'comercial.latam@ivgc.net'
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
	else
		flash[:error] = "Please enter a valid email!"
		redirect_to "/contact_us"
	end
	
  end 

 	def thanksForContacting
 		
 	end
 end
