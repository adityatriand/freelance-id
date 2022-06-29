class Feedback < ApplicationRecord
  belongs_to :freelancer
  belongs_to :user
end
