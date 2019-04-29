class Task < ApplicationRecord
  validates :name, :description, presence: true

  belongs_to :room
end
