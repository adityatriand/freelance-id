require 'rails_helper'

RSpec.describe Feedback, type: :model do

  let(:freelancer){
    user = FactoryBot.create(:user, role: 1)
    FactoryBot.create(:freelancer, user: user)
  }

  subject(:feedback) {
    @user = FactoryBot.create(:user, role: 2)
    FactoryBot.build(:feedback, user: @user, freelancer: freelancer)
  }
  
  context 'validation for all field' do
    it 'is valid when use valid attribut' do
      expect(feedback).to be_valid
    end

    it 'is not valid when use not valid attribut' do
      invalid_feedback = FactoryBot.build(:invalid_feedback, user: @user, freelancer: freelancer)
      expect(invalid_feedback).not_to be_valid
    end
  end
end
