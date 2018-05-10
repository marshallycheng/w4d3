class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  protect_from_forgery with: :exception
  def current_user
    return nil if session[:session_token] == nil
    # debugger
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def login_user!(user)
    # @current_user = user
    session[:session_token] = user.reset_session_token!
    redirect_to cats_url
  end

  def logout
    if logged_in?
      current_user.reset_session_token!
      session[:session_token] = nil
    end
  end

  def logged_out?
    !current_user
  end

  def logged_in?
    !!current_user
  end

  def require_logged_out
    redirect_to cats_url unless logged_out?
  end

  def require_logged_in
    redirect_to new_session_url unless logged_in?
  end

end
