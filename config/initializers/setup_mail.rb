ActionMailer::Base.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  domain:               'ciaotelecom.net',
  user_name:            'admin@ivgc.net',
  password:             'SWIu4*aDo*D#oucl',
  authentication:       'plain',
  enable_starttls_auto: true
}
ActionMailer::Base.default_url_options[:host] = "ivgc.net"