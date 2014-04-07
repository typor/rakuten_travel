class Hotel < ActiveRecord::Base
  validates :area_id, presence: true
  validates :no, presence: true, uniqueness: true, length: { maximum: 64 }
  validates :long_name, presence: true, length: { maximum: 255 }
  validates :short_name, length: { maximum: 32 }
  validates :postal_code, presence: true, length: { maximum: 8 }
  validates :address1, presence: true, length: { maximum: 64 }
  validates :address2, presence: true, length: { maximum: 255 }
  validates :telephone_no, presence: true, length: { maximum: 32 }
  validates :image_url, presence: true, length: { maximum: 512 }, url: true
  validates :url, presence: true, length: { maximum: 512 }, url: true
  validates :access, presence: true

  belongs_to :area
  has_many :plans
  has_many :rooms
  has_many :charges

  def safe_keys
    self.attributes.keys.select{|k, v| %w(id created_at updated_at).include?(k) != true }
  end

  def charges_by(start, finish)
    results = []
    rooms = Room.where(hotel_id: self.id).load
    start_day = start.days.since.strftime('%Y%m%d')
    finish_day = finish.days.since.strftime('%Y%m%d')
    rooms.each do |room|
      tp = {}

      start.upto(finish) do |i|
        tp[i.days.since.strftime('%Y%m%d').to_i] = {amount: 0, can_stay: false}
      end

      Charge.where(hotel_id: self.id, room_id: room.id).group(:plan_id).select('min(amount) as amount, can_stay, stay_day').where(["stay_day >= ? and stay_day <= ?", start_day, finish_day]).each do |f|
        if tp.key? f.stay_day
          tp[f.stay_day] = {amount: f.amount, can_stay: f.can_stay}
        end
      end
      results << {room: room, charges: tp}
    end
    results
  end
end
