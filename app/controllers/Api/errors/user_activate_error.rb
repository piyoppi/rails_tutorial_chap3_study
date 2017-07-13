module Api::Errors
  class UserActivateError < Base

    def detail
       "Account not activated. Check your email for the activation link."
    end

    def status_code
      401
    end

  end
end
