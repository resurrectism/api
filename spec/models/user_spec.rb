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
    it 'is invalid if it has a length less than 8 characters' do
      user.password = '1234567'

      expect(user).to be_invalid
      expect(user.errors).to have_key(:password)
      expect(user.errors[:password]).to include('must be at least 8 characters long')
    end

    it "is invalid if it doesn't include at least one number" do
      user.password = 'abcdefgh'

      expect(user).to be_invalid
      expect(user.errors).to have_key(:password)
      expect(user.errors[:password]).to include('must have at least one number')
    end

    it "is invalid if it doesn't include at least one lowercase letter" do
      user.password = 'ABCDEFG8'

      expect(user).to be_invalid
      expect(user.errors).to have_key(:password)
      expect(user.errors[:password]).to include('must have at least one lowercase letter')
    end

    it "is invalid if it doesn't include at least one uppercase letter" do
      user.password = 'abcdefg8'

      expect(user).to be_invalid
      expect(user.errors).to have_key(:password)
      expect(user.errors[:password]).to include('must have at least one uppercase letter')
    end

    it "is invalid if it doesn't include at least one symbol" do
      user.password = 'ABCDEFg8'

      expect(user).to be_invalid
      expect(user.errors).to have_key(:password)
      expect(user.errors[:password]).to include('must have at least one symbol')
    end

    it 'is valid if it is at least 8 chars long and include at least one number, one lowercase letter, one uppercase letter and a symbol' do
      user.password = 'ABCDEFg8$'
      user.password_confirmation = 'ABCDEFg8$'

      expect(user).to be_valid
    end
  end
end
