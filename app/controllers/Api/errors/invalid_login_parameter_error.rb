module Api::Errors
  class InvalidLoginParameterError < Base

    def detail
       "Invalid email/password combination"
    end

    def status_code
      401
    end

  end
end
