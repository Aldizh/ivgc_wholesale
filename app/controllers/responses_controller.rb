class ResponsesController < ApplicationController
  #before_filter :validateAdminLoggedIn

  def index
    @responses = Response.all
  end

  def show
    begin
      @response = Response.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'No response!'
      redirect_to '/responses'
    end
  end

  def new
     @response = Response.new
     session[:id] = params[:id]
  end

  def edit
    @response = Response.find(params[:id])
    puts "RESSSS"
    puts @response.inspect
  end

  def update
    @response = Response.find(params[:id])
    puts "ugdsgfad"
    puts @response.inspect
    respond_to do |format|
      if @response.update_attributes(params[:response])
        format.html { redirect_to @response, notice: 'Response was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @response.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @response = Response.new(params[:response])
    @response.ticket_id = session[:id]

    respond_to do |format|
      if @response.save
        @ticket = Ticket.where(:id => @response.ticket_id)[0]
        @ticket.update_attributes(:responded_to => true)
        format.html { redirect_to '/responses' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def destroy
    @response = Response.find(params[:id])
    @response.destroy
    redirect_to response_url
  end
end
