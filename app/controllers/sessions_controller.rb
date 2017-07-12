class SessionsController < ApplicationController

  def new
  end

  def create
    begin
      @user = User.login_auth(params[:session])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    rescue UserActivateError => e
      flash[:warning] = e.message
      redirect_to root_url
    rescue InvalidLoginParameterError => e
      flash.now[:danger] = e.message
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
