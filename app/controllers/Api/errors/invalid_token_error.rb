module Api::Errors
  class InvalidTokenError < Base

    def detail
       "Invalid access token."
    end

    def status_code
      401
    end

  end
end
