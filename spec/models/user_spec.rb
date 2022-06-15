require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) {
    FactoryBot.build(:user)
  }

  context 'validation for all field' do
    it 'is valid with an email, a password, and a role' do
      expect(user).to be_valid
    end
  end

  context 'validation for email field' do
    it 'is invalid without email' do
      user.email = nil
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end 

    it 'is invalid if use wrong format email' do
      user.email = "halo"
      user.valid?
      expect(user.errors[:email]).to include("is invalid")
    end

    it 'is invalid if use same email' do
      user1 = FactoryBot.create(:user, email: 'tes@gmail.com')
      user2 = FactoryBot.build(:user, email: 'tes@gmail.com')
      user2.valid?
      expect(user2.errors[:email]).to include("has already been taken")
    end

  end

  context 'validation for password field' do
    it 'is invalid without password' do
      user.password = nil
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end 

    it 'is invalid if password less than 8 characrter' do
      user.password = "12345"
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end

  end

  context 'validation for role field' do
    it 'is invalid without role' do
      user.role = nil
      user.valid?
      expect(user.errors[:role]).to include("can't be blank")
    end

    it 'is invalid if role filled with not numeric number' do
      user.role = "10s"
      user.valid?
      expect(user.errors[:role]).to include("is not a number")
    end

    it 'is invalid if role filled out of 0..2' do
      user.role = 3
      user.valid?
      expect(user.errors[:role]).to include("must be in 0..2")
    end

  end

end
