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
     puts "sesss"
     puts session[:id]
  end

  def create
    @response = Response.new(params[:response])
    @response.ticket_id = session[:id]

    respond_to do |format|
      if @response.save
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
