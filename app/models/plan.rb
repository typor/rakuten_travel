class Plan < ActiveRecord::Base
  belongs_to :hotel
  belongs_to :room
  validates :hotel_id, presence: true
  validates :room_id, presence: true
  validates :code, presence: true, numericality: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 3000 }
  validates :payment_code, presence: true, inclusion: { in: [0, 1, 2] }
  validates :point_rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 100 }
  validates :with_dinner, inclusion: {in: [true, false]}
  validates :with_breakfast, inclusion: {in: [true, false]}
end
