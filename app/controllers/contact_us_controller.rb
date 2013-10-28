require 'mail'
class ContactUsController < ApplicationController
  def index
  end

  def contactUs
	if validate_email(params[:email])
		session[:full_name] = params[:full_name]
		session[:email] = params[:email]
		session[:message] = params[:message]

		subject = "IVGC Customer Message: "

		if I18n.locale == :en
			begin
				UserMailer.contact_us({"fullname" => "#{params[:full_name]}", "email" => "#{params[:email]}", "subject" =>  "#{subject}", "message" => "#{params[:message]}"}).deliver
			 	redirect_to '/contact_us/thanksForContacting'
			
			rescue Exception => e
			 		flash[:error] = "You message was not sent! Please try again!"
			 		redirect_to contact_us_path
			end
		else
			begin 
				UserMailer.contact_us({"fullname" => "#{params[:full_name]}", "email" => "#{params[:email]}", "subject" =>  "#{subject}", "message" => "#{params[:mesage]}", "to" => "comercial.latam@ivgc.net"}).deliver
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
