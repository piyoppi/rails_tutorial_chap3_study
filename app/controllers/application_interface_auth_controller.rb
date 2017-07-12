class ApplicationInterfaceAuthController < ApplicationController
  protect_from_forgery with: :null_session
  include ApplicationInterfaceAuthHelper

  def create
    begin
      @user = User.login_auth(params)
      token = log_in_api @user
      render json: {message: "Login successful!", access_token: token, status: 200}
    rescue UserActivateError => e
      render json: {message: e.message, status: 401}
    rescue InvalidLoginParameterError => e
      render json: {message: e.message, status: 401}
    end
  end

end
