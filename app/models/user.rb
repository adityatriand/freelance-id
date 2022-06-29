class User < ApplicationRecord
    has_one :client, dependent: :destroy
    has_one :freelancer, dependent: :destroy
    has_many :portofolio, dependent: :destroy

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
    validates :password, presence: true, length: { minimum: 8 }
    validates :role, presence: true, numericality: { only_integer: true, in: 0..2 }

    has_secure_password
end
