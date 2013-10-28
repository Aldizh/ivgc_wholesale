class UserMailer < ActionMailer::Base
  #default from setting
  default from: "admin@ivgc.net"

  def welcome_email(user_hash)
  	@user = user_hash
    attachments.inline["logo.png"] = File.read('app/assets/images/ivgc_logo.png')
    mail(to: 'aldizhupani@gmail.com', subject: user_hash["subject"]) #for programmer testing
    mail(to: user_hash["email"], subject: user_hash["subject"]) #for notifying the customer
  end

  def sign_up_notification(user_hash)
    @user = user_hash
    attachments.inline["logo.png"] = File.read('app/assets/images/ivgc_logo.png')
    mail(to: 'sales@ivgc.net', subject: user_hash["subject"]) #for notifying sales@ivgc.net
    mail(to: 'aldizhupani@gmail.com', subject: user_hash["subject"]) #for notifying sales@ivgc.net
  end

  def contact_us(user_hash)
  	@user = user_hash
    attachments.inline["logo.png"] = File.read('app/assets/images/ivgc_logo.png')
    mail(to: 'aldizhupani@gmail.com', subject: user_hash["subject"])
    mail(to: 'sales@ivgc.net', subject: user_hash["subject"])
  end

  def thanks_for_payment(user_hash)
    @user = user_hash
    attachments.inline["logo.png"] = File.read('app/assets/images/ivgc_logo.png')
    mail(to: user_hash["email"], subject: user_hash["subject"])
    mail(to: 'aldizhupani@gmail.com', subject: user_hash["subject"])
  end

  def customer_payment(user_hash)
    @user = user_hash
    attachments.inline["logo.png"] = File.read('app/assets/images/ivgc_logo.png')
    mail(to: 'payments@ivgc.net', subject: user_hash["subject"])
    mail(to: 'aldizhupani@gmail.com', subject: user_hash["subject"])
  end

end
