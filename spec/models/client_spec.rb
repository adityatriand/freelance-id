require 'rails_helper'

RSpec.describe Client, type: :model do
  let(:user){
    FactoryBot.create(:user, role: 2)
  }

  subject(:client) {
    FactoryBot.build(:client, user: user)
  }

  context 'validation for all field' do
    it 'is valid with name, phone, date_birth, type_industry, and user_id' do
      expect(client).to be_valid
    end
  end

  context 'validation for name field' do
    it 'is invalid without name' do
      client.name = nil
      client.valid?
      expect(client.errors[:name]).to include("can't be blank")
    end 
  end

  context 'validation for phone field' do
    it 'is invalid without phone' do
      client.phone = nil
      client.valid?
      expect(client.errors[:phone]).to include("can't be blank")
    end

    it 'is invalid if use same phone' do
      client1 = Client.create(
        name: "Adit",
        phone: '089612345678',
        date_birth: '2001-01-01',
        type_industry: 'Technology',
        user: user
      )
      client2 = Client.new(
        name: "Adit",
        phone: '089612345678',
        date_birth: '2001-01-01',
        type_industry: 'Technology',
        user: user
      )
      client2.valid?
      expect(client2.errors[:phone]).to include("has already been taken")
    end

    it 'is invalid if phone filled with not numeric number' do
      client.phone = "089012345678s"
      client.valid?
      expect(client.errors[:phone]).to include("is not a number")
    end

    it 'is invalid if phone less than 10 characrter' do
      client.phone = "12345"
      client.valid?
      expect(client.errors[:phone]).to include("is too short (minimum is 10 characters)")
    end

    it 'is invalid if phone more than 15 characrter' do
      client.phone = "12345678910111213"
      client.valid?
      expect(client.errors[:phone]).to include("is too long (maximum is 15 characters)")
    end

  end

  context 'validation for birth date field' do
    it 'is invalid without date_birth' do
      client.date_birth = nil
      client.valid?
      expect(client.errors[:date_birth]).to include("can't be blank")
    end 
  end

  context 'vallidation for type industry field' do
    it 'is invalid without type_industry' do
      client.type_industry = nil
      client.valid?
      expect(client.errors[:type_industry]).to include("can't be blank")
    end 
  end

  context 'validation for user id field' do
    it 'is invalid without user' do
      client.user = nil
      client.valid?
      expect(client.errors[:user]).to include("must exist")
    end 
  end

end
