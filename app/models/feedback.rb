class Feedback < ApplicationRecord
  belongs_to :freelancer
  belongs_to :user

  validates :project_name, presence: true, length: { maximum: 20 }
  validates :description, presence: true, length: { minimum: 50 }
  validates :link_project, presence: true
  validates :testimoni, presence: true, length: { minimum: 20 }
  validates :rating, presence: true, numericality: { only_integer: true, in: 1..10 }

  def self.count_rating(id)
    where(freelancer_id: id).average("rating")
  end

end
