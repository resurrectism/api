require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    Fabricate(:user)
  end

  describe '#email' do
    it "is invalid if it doesn't include an @" do
      user.email = 'valid'

      expect(user).to be_invalid
      expect(user.errors).to have_key(:email)
    end

    it 'is invalid if it ends with an @' do
      user.email = 'valid@'

      expect(user).to be_invalid
      expect(user.errors).to have_key(:email)
    end

    it 'is valid with a valid email' do
      user.email = 'valid@valid.com'

      expect(user).to be_valid
    end
  end

  describe '#password' do
    def expect_password_invalid_with_error(password:, error_message:)
      user.password = password
      expect(user).to be_invalid
      expect(user.errors).to have_key(:password)
      expect(user.errors[:password]).to include(error_message)
    end

    it 'is invalid if it has a length less than 8 characters' do
      expect_password_invalid_with_error password: '1234567', error_message: 'must be at least 8 characters long'
    end

    it "is invalid if it doesn't include at least one number" do
      expect_password_invalid_with_error password: 'abcdefgh', error_message: 'must have at least one number'
    end

    it "is invalid if it doesn't include at least one lowercase letter" do
      expect_password_invalid_with_error password: 'ABCDEFG8', error_message: 'must have at least one lowercase letter'
    end

    it "is invalid if it doesn't include at least one uppercase letter" do
      expect_password_invalid_with_error password: 'abcdefg8', error_message: 'must have at least one uppercase letter'
    end

    it "is invalid if it doesn't include at least one symbol" do
      expect_password_invalid_with_error password: 'ABCDEFg8', error_message: 'must have at least one symbol'
    end

    it 'is valid if it fulfills all the requirements and the password_confirmation matches' do
      user.password = 'ABCDEFg8$'
      user.password_confirmation = 'ABCDEFg8$'

      expect(user).to be_valid
    end
  end
end
