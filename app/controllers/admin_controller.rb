class AdminController < ApplicationController
  before_filter :validateLoggedIn
  def index
  end

  def viewTickets
    # shows only owner's tickets if specified, default to show everyone if not specified
    @ownerFilter = params[:owner].to_s  # convert nil to empty string if method get

    # display parameter, options are all (default), yes (responded to), no (not responded to)
    if !params[:display].nil?
      @displayFilter = params[:display][:responded_to]
    else
      @displayFilter = 'all'
    end

    if @ownerFilter == ''
      if @displayFilter == 'all'
        @tickets = Ticket.all
      elsif @displayFilter == 'yes'
        @tickets = Ticket.where(responded_to: true)
      elsif @displayFilter == 'no'
        @tickets = Ticket.where(responded_to: false)
      end
    else
      if @displayFilter == 'all'
        @tickets = Ticket.where(owner: @ownerFilter)
      elsif @displayFilter == 'yes'
        @tickets = Ticket.where(owner: @ownerFilter, responded_to: true)
      elsif @displayFilter == 'no'
        @tickets = Ticket.where(owner: @ownerFilter, responded_to: false)
      end
    end
  end

  def accountInfo
    url = "https://208.65.111.144:8444/rest/Account/get_account_info/{'session_id':'#{get_session}'}/{'i_customer':'1552','i_account':'#{params[:i_account]}'}"
    @result = apiRequest(url)
  end

  def accountList
    url = "https://208.65.111.144:8444/rest/Account/get_account_list/{'session_id':'#{get_session}'}/{'i_customer':'1552'}"
    @result = apiRequest(url)
  end

  def accountTerminate
    url = "https://208.65.111.144/rest/Account/terminate_account/{'session_id':'#{get_session2}'}/{'i_account':'#{params[:i_account]}'}"
    @result = apiRequest(url)
    flash[:notice] = "Account (i_account: #{params[:i_account]}) terminated"
    redirect_to "/admin/index"
  end

end