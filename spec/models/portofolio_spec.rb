require 'rails_helper'

RSpec.describe Portofolio, type: :model do
  let(:user){
    FactoryBot.create(:user, role: 1)
  }

  subject(:portofolio) {
    FactoryBot.build(:portofolio, user: user)
  }
  
  context 'validation for all field' do
    it 'is valid when type project is personal' do
      portofolio.type_project = "personal"
      portofolio.client_name = nil
      portofolio.client_industry = nil
      expect(portofolio).to be_valid
    end

    it 'is valid when type project is client' do
      portofolio.type_project = "client"
      expect(portofolio).to be_valid
    end
  end
end
