class Api::AuthController < ApplicationController
  rescue_from Api::Errors::Base, with: :handle_error
  protect_from_forgery with: :null_session
  include Api::AuthHelper

  def create
    begin
      @user = User.login_auth(params)
      token = log_in_api @user
      render json: {message: "Login successful!", access_token: token, status: 200}
    rescue UserActivateError => e
      raise Api::Errors::UserActivateError 
    rescue InvalidLoginParameterError => e
      raise Api::Errors::InvalidLoginParameterError 
    end
  end

  def handle_error(error)
    render json: {message: error.detail, status: error.status_code}
  end

end
