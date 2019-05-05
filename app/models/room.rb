class Room < ApplicationRecord
  extend Enumerize

  validates :name, presence: true

  enumerize :status, in: %i[to_do in_progress done], default: :to_do

  belongs_to :apartment
  has_many :tasks, dependent: :nullify
  accepts_nested_attributes_for :tasks, allow_destroy: true
end
