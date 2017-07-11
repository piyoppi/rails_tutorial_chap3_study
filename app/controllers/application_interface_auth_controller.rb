class ApplicationInterfaceAuthController < ApplicationController
  protect_from_forgery with: :null_session
  include ApplicationInterfaceAuthHelper

  def create
    begin
      @user = User.login_auth(params)
      token = log_in_api @user
      render json: {message: "Login successful!", access_token: token}
    rescue UserActivateError => e
      render json: {message: e.message}
    rescue InvalidLoginParameterError => e
      render json: {message: e.message}
    end
  end

  def destroy
    begin
      log_out_api
      render json: {message: "Logout successful!"}
    rescue => e
      render json: {message: "Invalid access token.", token: get_request_api_token}
    end
  end
    
end
