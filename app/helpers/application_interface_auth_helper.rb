require 'jwt'

module ApplicationInterfaceAuthHelper

  def log_in_api(user)
    secret_key = "asdfjkhvlerADFGweohfgawoe"
    expire_sec = 3600
    payload = {iss: "example.com", exp: Time.now.to_i + expire_sec, user_id: user.id}
    return JWT.encode payload, secret_key, 'HS256'
  end

  def log_out_api(token)
    user = required_user(token)
    raise UserActivateError, "token is not found." if !user
    user.update_attribute(:api_digest, nil);
  end

  def logged_in_api?(token)
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

class UserMissingError < StandardError; end
