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
  
end
