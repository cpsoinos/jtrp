module JWTWrapper
  extend self

  def encode(payload, expiration = nil)
    expiration ||= 24

    payload = payload.dup
    payload['exp'] = expiration.to_i.hours.from_now.to_i

    JWT.encode payload, 'super secret'
  end

  def decode(token)
    begin
      decoded_token = JWT.decode token, 'super secret'

      decoded_token.first
    rescue
      nil
    end
  end
end
