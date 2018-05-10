class SessionsController < ApplicationController
  before_action :require_logged_out, only: [:new, :create]
  def new
    @user = User.new

    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:username], params[:user][:password])

    if @user
      login_user!(@user)
    else
      flash[:errors] = ["Invalid Username and Password Combination"]
      redirect_to new_session_url
    end
  end

  def destroy
    logout
    redirect_to new_session_url
  end
end
