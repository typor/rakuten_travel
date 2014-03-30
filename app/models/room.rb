class Room < ActiveRecord::Base
  validates :hotel_id, presence: true
  validates :code, presence: true, length: { maximum: 32 }, uniqueness: { scope: [:hotel_id, :code] }
  validates :name, presence: true, length: { maximum: 255 }
  validates :smoking, inclusion: {in: [true, false]}
  belongs_to :hotel
end
