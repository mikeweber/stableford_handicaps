class ApplicationController < ActionController::Base
  include ActionController::RequestForgeryProtection
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, store: :cookie

  def current_admin
    return if session[:admin_id].nil?

    @current_admin ||= Administrator.where(id: session[:admin_id]).take
  end

  helper_method :current_admin
end
