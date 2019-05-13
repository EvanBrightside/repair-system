class Subtask < ApplicationRecord
  extend Enumerize

  validates :name, :description, presence: true

  has_many_attached :photos
  has_many_attached :documents

  enumerize :status, in: %i[to_do in_progress done], default: :to_do

  belongs_to :task
end
