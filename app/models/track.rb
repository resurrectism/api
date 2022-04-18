class Track < ApplicationRecord
  validates :language, uniqueness: true, presence: true
end
