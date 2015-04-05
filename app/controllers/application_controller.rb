class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user

  def authenticate_user
    find_user
    redirect_to '/login' unless @current_user
  end

  def find_user
    @current_user = LoginUserFinder.new(session[:user_id]).find
  end

  def current_user
    @current_user
  end
  helper_method :current_user

  def require_staff
    redirect_to "/" unless current_user.staff?
  end

end
