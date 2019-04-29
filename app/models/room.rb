class Room < ApplicationRecord
  extend Enumerize

  validates :name, presence: true

  enumerize :status, in: %i[to_do in_progress done]

  belongs_to :apartment
  has_many :tasks, dependent: :nullify
end
