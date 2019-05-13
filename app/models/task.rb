class Task < ApplicationRecord
  extend Enumerize

  validates :name, :description, presence: true

  has_many_attached :render_photos
  has_many_attached :customer_photos
  has_many_attached :documents

  enumerize :status, in: %i[to_do in_progress done], default: :to_do

  belongs_to :room
  has_many :subtasks, dependent: :nullify
  accepts_nested_attributes_for :subtasks, allow_destroy: true
end
