class SessionsController < ApplicationController
  before_action :user_not_logged_in, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && !!user.authenticate(params[:session][:password])
      log_in user
      flash[:success] = "Login successfully"
      redirect_to user
    else
      flash[:danger] = "Invalid email/password combination"
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private
    def user_not_logged_in
      if logged_in?
        redirect_to user_path current_user
        flash[:warning] = "Plz log out before login"
      end
    end
end
