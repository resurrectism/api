class User < ApplicationRecord
  has_secure_password

  PASSWORD_HAS_AT_LEAST_ONE = {
    'number' => /(?=.*\d)/,
    'lowercase letter' => /(?=.*[a-z])/,
    'uppercase letter' => /(?=.*[A-Z])/,
    'symbol' => /(?=.*[[:^alnum:]])/,
  }.freeze

  validates :email, uniqueness: true, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :password_is_strong
  validates :password_confirmation, presence: true, on: :create

  def password_is_strong
    return unless password

    errors.add(:password, 'must be at least 8 characters long') unless password.length >= 8

    PASSWORD_HAS_AT_LEAST_ONE.each do |required_character, regex|
      errors.add(:password, "must have at least one #{required_character}") unless password.match(regex)
    end
  end
end
