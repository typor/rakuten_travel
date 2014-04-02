class Charge < ActiveRecord::Base
  belongs_to :hotel
  belongs_to :room
  belongs_to :plan

  validates :hotel_id, presence: true
  validates :room_id, presence: true
  validates :plan_id, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stay_day, presence: true, numericality: { greater_than_or_equal_to: 20140101 }, uniqueness: {scope: [:room_id, :plan_id, :stay_day] }
end
