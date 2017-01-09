class SessionsController < ApplicationController
  def new
    @admin = Administrator.new
  end

  def create
    if @admin = Administrator.find_by(email: params[:administrator][:email]).try(:authenticate, params[:administrator][:password])
      redirect_to root_path
    else
      render :new
    end
  end
end
