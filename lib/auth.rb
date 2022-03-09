require 'jwt'

class Auth
  ALGORITHM = 'HS256'
  EXPIRES_IN = 1.minute

  def self.issue(**payload)
    JWT.encode(payload.merge(claims), auth_secret, ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, auth_secret, ALGORITHM).first
  end

  def self.auth_secret
    Rails.application.credentials[:auth_secret]
  end

  def self.claims
    { exp: EXPIRES_IN.from_now.to_i }
  end
end
