module Api::Errors
  class UserMissingError < Base

    def detail
       "User is missing."
    end

    def status_code
      404
    end

  end
end
