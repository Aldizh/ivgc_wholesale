class TicketsController < ApplicationController
  before_filter :validateLoggedIn

  def index
    @tickets = Ticket.where(:owner => session[:current_login])
    puts @tickets.inspect
  end

  def show
    begin
      @ticket = Ticket.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Ticket does not exist!'
      redirect_to '/tickets'
    end
  end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.new(params[:ticket])
    @ticket.owner = session[:current_login]
    respond_to do |format|
      if @ticket.save
        flash[:notice] = "Ticket successfully created"
        format.html { redirect_to '/tickets' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    redirect_to ticket_url
  end

  def viewResponses
    begin
      @ticket = Ticket.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Ticket not found"
      return redirect_to action: "index"
    end
    if @ticket.owner != session[:current_login]
      flash[:error] = "You do not have permission to view this ticket"
      return redirect_to action: "index"
    end
    @responses = @ticket.responses
  end
end
