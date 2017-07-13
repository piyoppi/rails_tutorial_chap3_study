class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private 

    def logged_in_user
      unless logged_in?
        respond_to do |format|
          format.html {
            store_location
            flash[:danger] = "Please log in."
            redirect_to login_url
          }
          format.json {
            render json: {message: "Please log in."}, status: 401
          }
        end
      end
    end

end
