require 'socket'

class AccountsController < ApplicationController
  before_filter :validateLoggedIn

  def index
  end

  def accountInfo
    url = "https://208.65.111.144:8444/rest/Account/get_account_info/{'session_id':'#{get_session}'}/{'i_customer':'1552','i_account':'#{params[:i_account]}'}"
    @result = apiRequest(url)
  end

  def accountTerminate
    url = "https://208.65.111.144/rest/Account/terminate_account/{'session_id':'#{get_session2}'}/{'i_account':'#{params[:i_account]}'}"
    @result = apiRequest(url)
  end

  def accountList
    url = "https://208.65.111.144:8444/rest/Account/get_account_list/{'session_id':'#{get_session}'}/{'i_customer':'1552'}"
    @result = apiRequest(url)
  end

  def viewCDR
    if !params['page'].nil?
      @page = params['page'].to_i
    else
      @page = 1
    end
    @page_size = 20
    if params['to']
      @to_date = Time.new(*params['to'].split('-'))
    else
      @from_date = Time.now - 1.days
    end
    if params['from']
      @from_date = Time.new(*params['from'].split('-'))
    else
      @to_date = Time.now
    end

    @from_date_str = @from_date.strftime("%Y-%m-%d") + ' 00:00:00'
    @to_date_str = @to_date.strftime("%Y-%m-%d") + ' 23:59:59'
    offset = @page_size * (@page - 1)
    url = "https://208.65.111.144/rest/Account/get_xdr_list/{'session_id':'#{get_session2}'}/{'i_account':'#{session[:i_account]}','from_date':'#{@from_date_str}','to_date':'#{@to_date_str}','offset':'#{offset}','limit':'#{@page_size}'}"
    @calls = apiRequest(url)["xdr_list"]
  end


  # POST method to redirect to properly pass parameters to viewCDR
  def formatDate
    tmp = params['viewCDR']
    if !tmp.nil? and tmp.class==ActiveSupport::HashWithIndifferentAccess
      from_date = Time.new(tmp['from_date(1i)'], tmp['from_date(2i)'], tmp['from_date(3i)'])
      from_date_param = from_date.strftime("%Y-%m-%d")
      to_date = Time.new(tmp['to_date(1i)'], tmp['to_date(2i)'], tmp['to_date(3i)'])
      to_date_param = to_date.strftime("%Y-%m-%d")
    end
    redirect_to "/accounts/viewCDR?to=#{to_date_param}&from=#{from_date_param}"
  end

  def updateAccount
    # in this method, I get the account info and pass the necessary to the forms where user see what current info they have
    # and then can change it there and pass to another method whether the request for update will be sent.
    url = "https://208.65.111.144:8444/rest/Account/get_account_info/{'session_id':'#{get_session}'}/{'i_customer':'1552','i_account':'#{session[:i_account]}'}"
    @result = apiRequest(url)
    @comp_name = @result["account_info"]["companyname"]
    @user_name = @result["account_info"]["login"]
    @password = @result["account_info"]["h323_password"]
    @comp_name = @result["account_info"]["companyname"]
    @first_name = @result["account_info"]["firstname"]
    @last_name = @result["account_info"]["lastname"]
    @e_mail = @result["account_info"]["subscriber_email"]
    @phone1 = @result["account_info"]["phone1"].gsub(/[^0-9]/, "")  # remove non-numeric characters
    @phone2 = @result["account_info"]["phone2"].gsub(/[^0-9]/, "")
    @ip = @result["account_info"]["id"]
  end

  def update_error(company_name, ip, login, pw, first_name, last_name, email, cc, phone1, phone2)
    if not validate_ip(ip)
      return 'IP Invalid!'
    elsif not validate_company_name(company_name)
      return 'Company name is too long (41 characters max)!'
    elsif not validate_login(login)
      return 'Username cannot have fewer than 6 characters'
    elsif not validate_pw(pw)
      return 'Password must have 6-16 characters'
    elsif not validate_name(first_name)
      return 'First name cannot be more than 120 characters'
    elsif not validate_name(last_name)
      return 'Last name cannot be more than 120 characters'
    elsif not validate_email(email)
      return 'Email is not valid'
    elsif not validate_cc(cc)
      return 'Country code is not valid'
    elsif not validate_full_phone(phone1)
      return 'Primary phone number is not valid'
    # does not check validation of phone2 if it is empty
    elsif not !phone2.empty? and validate_full_phone(phone2)
      return 'Secondary phone number is not valid'
    else
      return nil  # validation passes
    end
  end

  def doUpdate
    @company_name = params[:companyname]
    @login = params[:username]
    @password = params[:password]
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @email = params[:email]
    @ip = params[:id]
    @phone1 = params[:phone1]
    @phone2 = params[:phone2]

    error = update_error(@company_name, @ip, @login, @password, @first_name, @last_name, @email, @ip, @phone1, @phone2)
    if not error.nil?
      flash[:error] = error
      return redirect_to "/accounts/updateAccount"
    end
    url = "https://208.65.111.144:8444/rest/Account/update_account/{'session_id':'#{get_session}'}/{'account_info':{'i_account':'#{session[:i_account]}','subscriber_email':'#{@email}','login':'#{@login}','password':'#{@password}','h323_password':'#{@password}','companyname':'#{@company_name}','id':'#{@ip}','phone1':'#{@phone1}','phone2':'#{@phone2}','firstname':'#{@first_name}','lastname':'#{@last_name}'}}"
    result = apiRequest(url)
           
    if result["i_account"].nil?
      flash[:error] = "Oops! Try again!"
      redirect_to "accounts/updateAccount"
    else 
      flash[:notice] = "You successfully updated your account infos"
      redirect_to root_path
    end
  end

  def manageIP
    #to get sesssion id
    url_id = "https://208.65.111.144:8444/rest/Account/get_account_info/{'session_id':'#{get_session}'}/{'i_customer':'1552','i_account':'#{session[:i_account]}'}"
    @result_id = apiRequest(url_id)

    #to get alias list
    @url =  "https://208.65.111.144:8444/rest/Account/get_alias_list/{'session_id':'#{get_session}'}/{'i_customer':'1552','i_master_account':'#{session[:i_account]}'}"

    #to get alias list
    @result = apiRequest(@url)
    if @result["alias_list"][1]
      @secondary = @result["alias_list"][1]["id"] || ''
    else
      @secondary = ''
    end
    if @result["alias_list"][2]
      @tertiary = @result["alias_list"][2]["id"] || ''
    else
      @tertiary = ''
    end
  end

  def updateIP
    @url = "https://208.65.111.144/rest/Account/add_alias/{'session_id':'#{get_session2}'}/{'alias_info':{'i_account':'#{session[:i_account]}','blocked':'Y','id':'#{params[:ip]}','i_master_account':'#{session[:i_account]}'}}"
    @result = apiRequest(@url)
    flash[:notice] = "you successfully added an alias IP address"
    redirect_to "/accounts/manageIP"
  end


  def deleteIP
    @url = "https://208.65.111.144/rest/Account/delete_alias/{'session_id':'#{get_session2}'}/{'alias_info':{'i_account':'#{session[:i_account]}','blocked':'Y','id':'#{params[:id]}','i_master_account':'#{session[:i_account]}'}}"
    @result = apiRequest(@url)
    flash[:notice] = "You successfully deleted this IP address!"
    redirect_to "/accounts/manageIP"
  end

  def addCredits
    
  end

  def addCreditsSubmit
    @amount = params[:amount].to_i*100
    response = EXPRESS_GATEWAY.setup_purchase(@amount,
    :ip                => getIP,
    :return_url        => accounts_creditAdded_url,
    :cancel_return_url => accounts_addCredits_url
    )
    session[:token] = response.token
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token) 
  end

  def creditAdded
    details = EXPRESS_GATEWAY.details_for(session[:token])
    @first = details.params["first_name"]
    @last = details.params["last_name"]
    @payment_amount = (details.params["PaymentDetails"]["OrderTotal"]).to_i || 0
  end

  def paymentConfirm
    details = EXPRESS_GATEWAY.details_for(session[:token])
    if details.message != "Success"
      flash[:error] = "There was a problem processing your request, please check the amount you entered!"
      redirect_to "/accounts/addCredits"
    else
      @payment_amount = (details.params["PaymentDetails"]["OrderTotal"]).to_i || 0
      response = EXPRESS_GATEWAY.purchase(@payment_amount*100, {:ip => getIP, :token => session[:token], :payer_id => details.payer_id})
      @url = "https://208.65.111.144/rest/Account/make_transaction/{'session_id':'#{get_session2}'}/{'i_account':'#{session[:i_account]}', 'amount':'1', 'action':'Manual Payment', 'visible_comment':'test payment', 'internal_comment':'Not Available', 'suppress_notification':'1'}"
      apiRequest(@url)
      flash[:notice] = "$#{@payment_amount}" + " was added to your account!"
    end
  end

  def getIP
    ip=Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
    ip.ip_address if ip
    return ip
  end

end


#working methods for accounts
# important to know that for credit account, use h323_password instead of password

# Access
# It is available for: 
# 1. Admin (https://<WEB-server>:443/rest/)  this is default. So you don't need to specify this.
# 2. Reseller (https://<WEB-server>:8444/rest/) 
# 3. Retail Customer (https://<WEB-server>:8444/rest/) 
# 4. Account (https://<WEB-server>:8445/rest/)


#https://208.65.111.144/rest/Session/login/{"login":"soap-webpanel","password":"wsw@c@8am"}
#https://208.65.111.144/rest/Account/get_account_list/{"session_id":"9dd4eccdcd7b97039fc6ce95e1a68b9f"}/{"i_customer":"1552"}
#https://208.65.111.144/rest/Account/get_account_info/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"i_customer":"1552","i_account":"877815"}
#https://208.65.111.144/rest/Account/update_account/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"account_info":{"i_account":"877815","subscriber_email":"ciaotest@ciao.com","login":"ciaotest","password":"ciaotest"}}
#https://208.65.111.144/rest/Account/terminate_account/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"i_account":"877771"}
#https://208.65.111.144/rest/Account/add_alias/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"alias_info":{"i_account":"877771","blocked":"Y","id":"23.43.13.3","i_master_account":"877783"}}
#https://208.65.111.144/rest/Account/get_alias_list/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"i_customer":"1552", "i_master_account":"637824637"}
#https://208.65.111.144/rest/Account/delete_alias/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"alias_info":{"i_account":"877815","blocked":"Y","id":"23.43.13.3","i_master_account":"877815"}}
#https://208.65.111.144/rest/Account/make_transaction/{"session_id":"9dd4eccdcd7b97039fc6ce95e1a68b9f"}/{"i_account":"877864", "amount":"1", "action":"Manual Payment", "visible_comment":"test payment", "internal_comment":"Not Available", "suppress_notification":"1"}
#https://208.65.111.144/rest/Account/get_xdr_list/{"session_id":"9dd4eccdcd7b97039fc6ce95e1a68b9f"}/{"i_account":"877815", "from_date":"2011-10-20 16:27:25", "to_date":"2013-06-30 16:27:25"}
#https://208.65.111.144/rest/Session/logout/{"session_id":""}
