class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationInterfaceAuthHelper

  private 

    def logged_in_user
      unless logged_in? || logged_in_api?
        respond_to do |format|
          format.html {
            store_location
            flash[:danger] = "Please log in."
            redirect_to login_url
          }
          format.json {
            render json: { message: "Please log in." }
          }
        end
      end
    end

end
