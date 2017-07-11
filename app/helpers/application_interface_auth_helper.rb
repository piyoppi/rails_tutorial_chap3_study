require 'base64'

module ApplicationInterfaceAuthHelper


  def log_in_api(user)
    secret_key = "asdfjkhvlerADFGweohfgawoe"
    header = {type: "JWT", alg: "HS256"}
    payload = {iss: "example.com", exp: 1466839180, user_id: 33}
    header_base64 = Base64.urlsafe_encode64(header.to_s)
    payload_base64 = Base64.urlsafe_encode64(payload.to_s)
    signature = Digest::SHA256.hexdigest("#{header_base64}.#{payload_base64}.#{secret_key}")
    api_token = "#{header_base64}.#{payload_base64}.#{signature}"
    user.update_attribute(:api_digest, api_token);
    return api_token
  end

  def current_user_api(token=nil)
    token ||= get_request_api_token;
    @current_user_api ||= User.find_by(api_digest: token)
  end

  def log_out_api(token=nil)
    token ||= get_request_api_token;
    raise InvalidTokenError, "token is not found." unless token
    user = current_user_api(token)
    raise UserMissingError, "user is not found." unless user
    user.update_attribute(:api_digest, nil);
  end

  def logged_in_api?(token=nil)
    token ||= get_request_api_token;
    return nil if token.nil?
    user = current_user_api(token)
    return !!@current_user_api
  end

  def get_request_api_token
    return request.headers[:HTTP_AUTHORIZATION]
  end
end

class UserMissingError < StandardError; end
class InvalidTokenError < StandardError; end
