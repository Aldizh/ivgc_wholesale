class AdminController < ApplicationController
  before_filter :validateAdmin

  def viewTickets
    # shows only owner's tickets if specified, default to show everyone if not specified
    ownerFilter = params[:owner]

    # display parameter, options are all (default), yes (responded to), no (not responded to)
    if !params[:display].nil?
      displayFilter = params[:display]
    else
      displayFilter = 'all'
    end

    if ownerFilter.nil?
      if displayFilter == 'all'
        @tickets = Ticket.all
      else
        @tickets = Ticket.where(responded_to: displayFilter)
      end
    else
      if displayFilter == 'all'
        @tickets = Ticket.where(owner: ownerFilter)
      else
        @tickets = Ticket.where("responded_to = ? AND owner = ?", displayFilter, ownerFilter)
      end
    end
  end

  #incomplete
  def viewResponsesToUser
    # if parameter to is specified, get all responses made to user to
    toFilter = params[:to]

    if toFilter.nil?
      @responses = Response.all
    else
      @responses = Response.where("ticket_id = ?", params[:to])
    end
  end


end