class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private 
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "flash.logged_in_user"
      redirect_to login_url
    end
  end

  def verify_admin
    unless current_user.admin?
      flash[:danger] = t "flash.denied_user"
      redirect_to root_url
    end
  end
end
