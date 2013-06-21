class AccountsController < ApplicationController
  def index
    puts session[:session_id]
  end

  def account_list
    if session[:current_user_id]
      @url = "https://208.65.111.144/rest/Account/get_account_list/%7B%22session_id%22:%22a36a398ebd51edcea8ac936b21fa299c%22%7D/%7B%22i_customer%22:%221552%22%7D"
      @response = RestClient::Request.new(
        :method => :post,
        :url => @url,
        :headers => { :accept => :json, :content_type => :json}).execute
      @result = ActiveSupport::JSON.decode(@response)
    else
      flash[:error] = " Please login to continue! "
      redirect_to root_path
    end
  end

  def update_account
    if session[:current_user_id]
      @email = params[:email]
      @phone = params[:phone]
      @cc = params[:cc]

      session[:email] = @email
      session[:phone] = @phone
      session[:cc] = @cc
      if validate_email(@email)
        if validate_cc(@cc) and validate_phone(@phone)
          @full_phone = @cc + @phone
          @url = "https://208.65.111.144/rest/Account/update_account/%7B%22session_id%22:%22a36a398ebd51edcea8ac936b21fa299c%22%7D/%7B%22id%22:%22302302302303old000%22,%22account_info%22:%7B%22blocked%22:%22N%22,%22i_account%22:877660,%22mac%22:null,%22bill_status%22:%22O%22,%22life_time%22:%2290%22,%22u_expiration_date%22:null,%22in_date_format%22:%22YYYY-MM-TT%22,%22i_time_zone%22:%221%22,%22phone2%22:null,%22billing_model%22:%22-1%22,%22summary_only%22:%22N%22,%22u_activation_date%22:%221319068800%22,%22country%22:%22Zimbabwe%22,%22i_customer_site%22:%22www.google.com%22,%22x_i_subscriber%22:%223557%22,%22i_distributor%22:null,%22customer_credit_exceed%22:null,%22follow_me_enabled%22:%22N%22,%22i_routing_plan%22:%222%22,%22i_master_account%22:null,%22product_name%22:%22Ciao-Test%22,%22activation_date%22:%222011-10-20%22,%22firstname%22:null,%22baddr2%22:null,%22iso_4217%22:%22BRL%22,%22iso_639_1%22:%22en%22,%22i_env%22:%221%22,%22timer%22:null,%22zero_balance%22:null,%22state%22:null,%22opening_balance%22:%225.00000%22,%22has_custom_fields%22:0,%22customer_bill_suspended%22:%220%22,%22profitability%22:%22100%22,%22id%22:%22302302302303old000%22,%22baddr4%22:null,%22out_date_time_format%22:%22YYYY-MM-DD%20HH24:MI:SS%22,%22i_moh%22:null,%22last_usage%22:null,%22subscriber_email%22:%22#{@email}%22,%22redirect_number%22:null,%22h323_password%22:null,%22management_number%22:null,%22i_lang%22:%22en%22,%22baddr3%22:null,%22idle_days%22:null,%22baddr5%22:null,%22zip%22:null,%22first_usage%22:null,%22balance%22:%225.00000%22,%22i_subscriber%22:%223557%22,%22customer_name%22:%22Ciao%20Calling%20Card%20BRL%22,%22midinit%22:null,%22cont1%22:null,%22zero_balance_date%22:null,%22customer_blocked%22:%22N%22,%22lastname%22:null,%22city%22:null,%22cont2%22:null,%22out_time_format%22:%22HH24:MI:SS%22,%22i_vd_plan%22:null,%22service_features%22:%5B%5D,%22customer_status%22:%22credit_exceed%22,%22ecommerce_enabled%22:%22N%22,%22in_time_format%22:%22HH24:MI:SS%22,%22password_timestamp%22:null,%22expiration_date%22:null,%22service_flags%22:%22%22,%22note%22:null,%22bcc%22:null,%22issue_date%22:%222011-10-21%22,%22faxnum%22:null,%22control_number%22:%228510%22,%22last_recharge%22:null,%22i_acl%22:%22155%22,%22i_customer%22:%221552%22,%22companyname%22:null,%22baddr1%22:null,%22credit_limit%22:null%7D%7D"
          @uri = @url
          begin 
            @response = RestClient::Request.new(
              :method => :post,
              :url => @uri,
              :headers => { :accept => :json, :content_type => :json}).execute
            @result = ActiveSupport::JSON.decode(@response)
            redirect_to "/accounts", notice: "Sign up successful!"
          rescue RestClient::InternalServerError
            flash[:error] = "Sorry, couldn't connect to server"
          end
        else
          flash[:error] = "Phone Number is not valid"
        end
      else
        flash[:error] = "Email is not valid"
      end
    else
      flash[:error] = "Please login to continue!"
      redirect_to root_path
    end
    #https://208.65.111.144/rest/Account/update_account/%7B%22session_id%22:%2292468dd777ef8445f8b2a3c3d077e6e9%22%7D/%7B%22id%22:%22302302302303old000%22,%22account_info%22:%7B%22blocked%22:%22N%22,%22i_account%22:877660,%22mac%22:null,%22bill_status%22:%22O%22,%22life_time%22:%2290%22,%22u_expiration_date%22:null,%22in_date_format%22:%22YYYY-MM-TT%22,%22i_time_zone%22:%221%22,%22phone2%22:null,%22billing_model%22:%22-1%22,%22summary_only%22:%22N%22,%22u_activation_date%22:%221319068800%22,%22country%22:%22Zimbabwe%22,%22i_customer_site%22:%22www.google.com%22,%22x_i_subscriber%22:%223557%22,%22i_distributor%22:null,%22customer_credit_exceed%22:null,%22follow_me_enabled%22:%22N%22,%22i_routing_plan%22:%222%22,%22i_master_account%22:null,%22product_name%22:%22Ciao-Test%22,%22activation_date%22:%222011-10-20%22,%22firstname%22:null,%22baddr2%22:null,%22iso_4217%22:%22BRL%22,%22iso_639_1%22:%22en%22,%22i_env%22:%221%22,%22timer%22:null,%22zero_balance%22:null,%22state%22:null,%22opening_balance%22:%225.00000%22,%22has_custom_fields%22:0,%22customer_bill_suspended%22:%220%22,%22profitability%22:%22100%22,%22id%22:%22302302302303old000%22,%22baddr4%22:null,%22out_date_time_format%22:%22YYYY-MM-DD%20HH24:MI:SS%22,%22i_moh%22:null,%22last_usage%22:null,%22subscriber_email%22:null,%22redirect_number%22:null,%22h323_password%22:null,%22management_number%22:null,%22i_lang%22:%22en%22,%22baddr3%22:null,%22idle_days%22:null,%22baddr5%22:null,%22zip%22:null,%22first_usage%22:null,%22balance%22:%225.00000%22,%22i_subscriber%22:%223557%22,%22customer_name%22:%22Ciao%20Calling%20Card%20BRL%22,%22midinit%22:null,%22cont1%22:null,%22zero_balance_date%22:null,%22customer_blocked%22:%22N%22,%22lastname%22:null,%22city%22:null,%22cont2%22:null,%22out_time_format%22:%22HH24:MI:SS%22,%22i_vd_plan%22:null,%22service_features%22:%5B%5D,%22customer_status%22:%22credit_exceed%22,%22ecommerce_enabled%22:%22N%22,%22in_time_format%22:%22HH24:MI:SS%22,%22password_timestamp%22:null,%22expiration_date%22:null,%22service_flags%22:%22%22,%22note%22:null,%22bcc%22:null,%22issue_date%22:%222011-10-21%22,%22faxnum%22:null,%22control_number%22:%228510%22,%22last_recharge%22:null,%22i_acl%22:%22155%22,%22i_customer%22:%221552%22,%22companyname%22:null,%22baddr1%22:null,%22credit_limit%22:null%7D%7D
  end

  def new_form
  end

end
