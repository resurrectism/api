require 'jwt'

class Auth
  ALGORITHM = 'HS256'.freeze
  EXPIRES_IN = 100.minutes
  REFRESH_TOKEN_EXPIRES_IN = 1.day

  def self.random_base64
    SecureRandom.base64(16)
  end

  def self.issue_access_token(**payload)
    JWT.encode(claims.merge(payload), auth_secret, ALGORITHM)
  end

  def self.issue_refresh_token(**payload)
    JWT.encode(refresh_token_claims.merge(payload), refresh_token_auth_secret, ALGORITHM)
  end

  def self.decode_access_token(token)
    JWT.decode(token, auth_secret, ALGORITHM).first
  end

  def self.decode_refresh_token(token)
    JWT.decode(token, refresh_token_auth_secret, ALGORITHM).first
  end

  def self.auth_secret
    Rails.application.credentials[:auth_secret]
  end

  def self.refresh_token_auth_secret
    Rails.application.credentials[:refresh_token_auth_secret]
  end

  def self.claims
    { exp: EXPIRES_IN.from_now.to_i }
  end

  def self.refresh_token_claims
    { exp: REFRESH_TOKEN_EXPIRES_IN.from_now.to_i }
  end
end
