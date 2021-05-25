class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    user = user&.authenticate(params[:password]) unless current_user.admin?
    if user
      session[:user_id] = user.id
      redirect_to user.admin? ? problems_path : notes_path
    else
      flash.now[:alert] = t("session.invalid")
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
