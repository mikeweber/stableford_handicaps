class AdminApplicationController < ApplicationController
  before_filter :require_login

  private

  def require_login
    redirect_to(new_session_path) and return false unless current_admin
  end

  def current_admin
    return if session[:admin_id].nil?

    @current_admin ||= Administrator.where(id: session[:admin_id]).take
  end
end
