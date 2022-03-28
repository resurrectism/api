class UserResource < BaseResource
  attributes :email, :password, :password_confirmation

  def fetchable_fields
    [:email]
  end

  def self.creatable_fields(_context)
    %i[email password password_confirmation]
  end
end
