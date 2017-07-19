class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include Api::AuthHelper
  include ApplicationHelper

  private 

  def logged_in_user

    respond_to do |format|
      format.html {
        unless logged_in? 
          store_location
          flash[:danger] = "Please log in."
          redirect_to login_url
        end
      }
      format.json {
        unless valid_token?
          render json: {message: "Please log in."}, status: 401
        end
      }
    end

  end

end
