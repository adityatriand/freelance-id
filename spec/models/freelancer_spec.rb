require 'rails_helper'

RSpec.describe Freelancer, type: :model do
  let(:user){
    FactoryBot.create(:user, role: 2)
  }

  subject(:freelancer) {
    FactoryBot.build(:freelancer, user: user)
  }

  context 'validation for all field' do
    it 'is valid with name, phone, date_birth, category_work, and user_id' do
      expect(freelancer).to be_valid
    end
  end

  context 'validation for name field' do
    it 'is invalid without name' do
      freelancer.name = nil
      freelancer.valid?
      expect(freelancer.errors[:name]).to include("can't be blank")
    end 
  end

  context 'validation for phone field' do
    it 'is invalid without phone' do
      freelancer.phone = nil
      freelancer.valid?
      expect(freelancer.errors[:phone]).to include("can't be blank")
    end

    it 'is invalid if use same phone' do
      freelancer1 = Freelancer.create(
        name: "Adit",
        phone: '089612345678',
        date_birth: '2001-01-01',
        category_work: 'Technology',
        user: user
      )
      freelancer2 = Freelancer.new(
        name: "Adit",
        phone: '089612345678',
        date_birth: '2001-01-01',
        category_work: 'Technology',
        user: user
      )
      freelancer2.valid?
      expect(freelancer2.errors[:phone]).to include("has already been taken")
    end

    it 'is invalid if phone filled with not numeric number' do
      freelancer.phone = "089012345678s"
      freelancer.valid?
      expect(freelancer.errors[:phone]).to include("is not a number")
    end

    it 'is invalid if phone less than 10 characrter' do
      freelancer.phone = "12345"
      freelancer.valid?
      expect(freelancer.errors[:phone]).to include("is too short (minimum is 10 characters)")
    end

    it 'is invalid if phone more than 15 characrter' do
      freelancer.phone = "12345678910111213"
      freelancer.valid?
      expect(freelancer.errors[:phone]).to include("is too long (maximum is 15 characters)")
    end

  end

  context 'validation for birth date field' do
    it 'is invalid without date_birth' do
      freelancer.date_birth = nil
      freelancer.valid?
      expect(freelancer.errors[:date_birth]).to include("can't be blank")
    end 
  end

  context 'vallidation for category work field' do
    it 'is invalid without category_work' do
      freelancer.category_work = nil
      freelancer.valid?
      expect(freelancer.errors[:category_work]).to include("can't be blank")
    end 
  end

  context 'validation for user id field' do
    it 'is invalid without user' do
      freelancer.user = nil
      freelancer.valid?
      expect(freelancer.errors[:user]).to include("must exist")
    end 
  end

end
