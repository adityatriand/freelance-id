class Client < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :phone, presence: true
  validates :date_birth, presence: true
  validates :type_industry, presence: true
  validates :user_id, presence: true
  validates :phone, numericality: true, length: { minimum: 10, maximum: 15 }, uniqueness: true

end
