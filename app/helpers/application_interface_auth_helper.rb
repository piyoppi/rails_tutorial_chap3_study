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

  def log_out_api(token)
    user = User.find_by(api_digest: token)
    raise UserActivateError, "token is not found." if !user
    user.update_attribute(:api_digest, nil);
  end

  def logged_in_api?(token)
    return nil if token.nil?
    !!User.find_by(api_digest: token); 
  end

end

class UserMissingError < StandardError; end
