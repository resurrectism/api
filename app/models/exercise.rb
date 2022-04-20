class Exercise < ApplicationRecord
  belongs_to :track

  validates :name, presence: true, uniqueness: { scope: :track_id }
end
