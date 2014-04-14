class Charge < ActiveRecord::Base
  belongs_to :hotel
  belongs_to :room
  belongs_to :plan
  has_many :histories, class_name: "ChargeHistory", dependent: :delete_all
  validates :hotel_id, presence: true
  validates :room_id, presence: true
  validates :plan_id, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stay_day, presence: true, numericality: { greater_than_or_equal_to: 20140101 }, uniqueness: {scope: [:room_id, :plan_id, :stay_day] }

  def latest_history
    ChargeHistory.where(charge_id: self.id).order(id: :desc).first
  end

  def same?
    before = latest_history
    before && before.amount == self.amount && before.can_stay == self.can_stay
  end

  def add_history(researched = nil)
    return false if new_record?
    return true if same?

    researched ||= 0.days.since.strftime('%Y-%m-%d %H:%M:%S')
    history = ChargeHistory.new(charge_id: self.id, amount: self.amount, researched_at: researched, can_stay: self.can_stay)
    return history.save
  end
end
