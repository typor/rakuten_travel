class HotelStay
include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attr_accessor :hotel, :year, :month

  validates :hotel, presence: true
  validates :year, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 2014, less_than: 2030 }
  validates :month, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 13 }

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def search
    return nil if invalid? || !hotel.is_a?(Hotel)

    Charge.where(room_id: hotel.rooms.enabled.ids, plan_id: hotel.plans.enabled.ids, can_stay: true).within(start_day, finish_day)
  end

  def start_day(format = true, refresh = false)
    if !defined?(@start_day) || refresh
      @start_day = DateTime.new(year, month, 1)
    end
    format ? @start_day.strftime('%Y%m%d').to_i : @start_day
  end

  def finish_day(format = true, refresh = false)
    if !defined?(@finish_day) || refresh
      @finish_day = DateTime.new(year, month, 1).end_of_month
    end
    format ? @finish_day.strftime('%Y%m%d').to_i : @finish_day
  end

  def persisted?
    false
  end
end