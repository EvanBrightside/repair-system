class Apartment < ApplicationRecord
  extend Enumerize

  validates :owner, :address, presence: true

  has_one_attached :floor_plan
  has_one_attached :unit_plan
  has_many_attached :unit_photos
  has_many_attached :documents

  enumerize :status, in: %i[to_do in_progress done]

  has_many :rooms, dependent: :nullify
end
