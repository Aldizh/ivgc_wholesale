class AdminController < ApplicationController
  before_filter :validateAdmin

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

end