class AdminApplicationController < ApplicationController
  before_action :require_login

  private

  def require_login
    redirect_to(new_session_path) and return false unless current_admin
  end
end
