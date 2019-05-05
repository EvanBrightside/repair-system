class Task < ApplicationRecord
  extend Enumerize

  validates :name, :description, presence: true

  enumerize :status, in: %i[to_do in_progress done], default: :to_do

  belongs_to :room
end
