class SessionsController < ApplicationController
  def new
    @admin = Administrator.new
  end

  def create
    if @admin = Administrator.find_by(email: params[:administrator][:email]).try(:authenticate, params[:administrator][:password])
      session[:admin_id] = @admin.id
      redirect_to admin_rounds_path
    else
      render :new
    end
  end

  def delete
    session[:admin_id] = @current_admin = nil
    redirect_to root_path
  end
end
