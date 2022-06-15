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

end
