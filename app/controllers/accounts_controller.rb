class AccountsController < ApplicationController
  before_filter :validateLoggedIn

  def validateLoggedIn
    if not session[:current_login]
      flash[:error] = "Please login to continue!"
      return redirect_to "/sessions/new"
    end
  end

  def index
    details = EXPRESS_GATEWAY.details_for(session[:token])
    puts "DETTTT"
    puts details.payer_id
    puts (details.params["PaymentDetails"]["OrderTotal"]).to_i
    #:ip => "107.1.109.42",
    #:token => express_token
    #:payer_id => express_payer_id
    #puts details.params["PayerInfo"]["PayerID"]

    #this is where we process teh purchase
    #EXPRESS_GATEWAY.purchase((details.params["PaymentDetails"]["OrderTotal"]*100).to_i, {:ip => "107.1.109.42", :token => session[:token], :payer_id => details.payer_id})
  end


  def accountInfo
    @url = "https://208.65.111.144/rest/Account/get_account_info/{'session_id':'#{@@session_id}'}/{'i_customer':'1552', 'i_account':'#{params[:i_account]}'}"
    @result = apiRequest(@url)
  end

  def accountTerminate
    @url = "https://208.65.111.144/rest/Account/terminate_account/{'session_id':'#{@@session_id}'}/{'i_account':'#{params[:i_account]}'}"
    @result = apiRequest(@url)
  end

  def accountList
    @url = "https://208.65.111.144/rest/Account/get_account_list/{'session_id':'#{@@session_id}'}/{'i_customer':'1552'}"
    @result = apiRequest(@url)
  end

  def updateAccount
    # in this method, I get the account info and pass the necessary to the forms where user see what current info they have
    # and then can change it there and pass to another method whether the request for update will be sent.
    @url = "https://208.65.111.144/rest/Account/get_account_info/{'session_id':'#{@@session_id}'}/{'i_customer':'1552', 'i_account':'#{session[:i_account]}'}"
    @result = apiRequest(@url)
    @comp_name = @result["account_info"]["companyname"]
    @user_name = @result["account_info"]["login"]
    @password = @result["account_info"]["password"]
    @comp_name = @result["account_info"]["companyname"]
    @first_name = @result["account_info"]["firstname"]
    @last_name = @result["account_info"]["lastname"]
    @e_mail = @result["account_info"]["subscriber_email"]
    @phone1 = @result["account_info"]["phone1"]
    @phone2 = @result["account_info"]["phone2"]
    @ip = @result["account_info"]["id"]
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
    if not validate_login(@login)
      flash[:error] = "Username cannot have fewer than 6 characters"
      return redirect_to "/accounts/updateAccount"
    elsif not validate_pw(@password)
      flash[:error] = "Password cannot have fewer than 6 characters"
      return redirect_to "/accounts/updateAccount"
    elsif not validate_email(@email)
      flash[:error] = "Email is not valid"
      return redirect_to "/accounts/updateAccount"
    end
    @url = "https://208.65.111.144/rest/Account/update_account/{'session_id':'#{@@session_id}'}/{'account_info':{'i_account':'#{session[:i_account]}','subscriber_email':'#{@email}','login':'#{@login}','password':'#{@password}', 'companyname':'#{@company_name}','id':'#{@ip}','phone1':'#{@phone1}','phone2':'#{@phone2}','firstname':'#{@first_name}','lastname':'#{@last_name}'}}"
    @result = apiRequest(@url)
           
    if @result["i_account"].nil?
      flash[:error] = "Oops! Try again!"
      redirect_to "accounts/updateAccount"
    else 
      flash[:notice] = "You successfully updated your account infos"
      redirect_to root_path
    end
  end

  def manageIP
    #to get sesssion id
    @url_id = "https://208.65.111.144/rest/Account/get_account_info/{'session_id':'#{@@session_id}'}/{'i_customer':'1552', 'i_account':'#{session[:i_account]}'}"
    @result_id = apiRequest(@url_id)

    #to get alias list
    @url =  "https://208.65.111.144/rest/Account/get_alias_list/{'session_id':'#{@@session_id}'}/{'i_customer':'1552', 'i_master_account':'#{session[:i_account]}'}"
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
    @url = "https://208.65.111.144/rest/Account/add_alias/{'session_id':'#{@@session_id}'}/{'alias_info':{'i_account':'#{session[:i_account]}','blocked':'Y','id':'#{params[:ip]}','i_master_account':'#{session[:i_account]}'}}"
    @result = apiRequest(@url)
    flash[:notice] = "you successfully added an alias IP address"
    redirect_to "/accounts/manageIP"
  end


  def deleteIP
    @url = "https://208.65.111.144/rest/Account/delete_alias/{'session_id':'#{@@session_id}'}/{'alias_info':{'i_account':'#{session[:i_account]}','blocked':'Y','id':'#{params[:id]}','i_master_account':'#{session[:i_account]}'}}"
    @result = apiRequest(@url)
    flash[:notice] = "You successfully deleted this IP address!"
    redirect_to "/accounts/manageIP"
  end

  def payment
    @amount = 100
    response = EXPRESS_GATEWAY.setup_purchase(@amount,
    :ip                => "107.1.109.42",
    :return_url        => accounts_url,
    :cancel_return_url => accounts_url
    )
    session[:token] = response.token
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

end
 
#working methods for accounts
#https://208.65.111.144/rest/Session/login/{"login":"soap-webpanel","password":"wsw@c@8am"}
#https://208.65.111.144/rest/Account/get_account_list/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"i_customer":"1552"}
#https://208.65.111.144/rest/Account/get_account_info/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"i_customer":"1552","i_account":"877815"}
#https://208.65.111.144/rest/Account/update_account/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"account_info":{"i_account":"877815","subscriber_email":"ciaotest@ciao.com","login":"ciaotest","password":"ciaotest"}}
#https://208.65.111.144/rest/Account/terminate_account/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"i_account":"877771"}
#https://208.65.111.144/rest/Account/add_alias/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"alias_info":{"i_account":"877771","blocked":"Y","id":"23.43.13.3","i_master_account":"877783"}}
#https://208.65.111.144/rest/Account/get_alias_list/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"i_customer":"1552", "i_master_account":"877783"}
#https://208.65.111.144/rest/Account/delete_alias/{"session_id":"95bd4c36c2f629928d3aca1b410d43e5"}/{"alias_info":{"i_account":"877815","blocked":"Y","id":"23.43.13.3","i_master_account":"877815"}}



