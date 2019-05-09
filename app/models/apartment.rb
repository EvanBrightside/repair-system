class Apartment < ApplicationRecord
  extend Enumerize

  validates :owner, :address, presence: true

  has_many_attached :plans
  has_many_attached :photos
  has_many_attached :documents

  enumerize :status, in: %i[to_do in_progress done]

  has_many :rooms, dependent: :nullify
  accepts_nested_attributes_for :rooms, allow_destroy: true
end
