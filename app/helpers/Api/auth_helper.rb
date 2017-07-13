module Api::AuthHelper

  def generate_token(user)
    exptime = Time.now.to_i + Rails.application.secrets.api_token_exp
    payload = {iss: "example.com", exp: exptime, user_id: user.id}
    JWT.encode payload, Rails.application.secrets.api_secret_key, 'HS256'
  end

  def valid_token?(token)
    !!required_user(token)
  end

  private
    
    def decoded_token(token)
      JWT.decode token, secret_key, true, algorithm: 'HS256'
    end

    def required_user(token)
      token_params = decoded_token(token)
      @required_user = User.find_by(id: token_params[:id])
    end

end
