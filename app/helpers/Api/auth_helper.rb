module Api::AuthHelper

  def generate_token(user)
    exptime = Time.now.to_i + Rails.application.secrets.api_token_exp
    payload = {iss: "example.com", exp: exptime, user_id: user.id}
    JWT.encode payload, Rails.application.secrets.api_secret_key, 'HS256'
  end

  def valid_token?(token=nil)
    token ||= token_from_request
    !!current_user_by_apitoken(token)
  end

  def current_user_by_apitoken(token=nil)
    token ||= token_from_request
    token_params = decoded_token(token)
    raise Api::Errors::InvalidTokenError unless token_params
    @current_user_by_apitoken = User.find_by(id: token_params[0]["user_id"])
  end

  private

    def decoded_token(token)
      return nil if token.blank?
      begin
        JWT.decode token, Rails.application.secrets.api_secret_key, true, algorithm: 'HS256'
      rescue => e
        raise Api::Errors::InvalidTokenError
      end
    end

    def token_from_request 
      return request.headers[:HTTP_AUTHORIZATION]
    end

end
