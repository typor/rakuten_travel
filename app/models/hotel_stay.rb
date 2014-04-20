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

  def build_plan_url(stay_day, span = 1)
    url = Settings.plan_urls.sample
    start = DateTime.strptime(stay_day.to_s, '%Y%m%d')
    finish = start + span.days
    url + "?f_no=#{hotel.no}&f_flg=PLAN&f_hi1=#{start.day}&f_tuki1=#{start.month}&f_nen1=#{start.year}&f_hi2=#{finish.day}&f_tuki2=#{finish.month}&f_nen2=#{finish.year}&f_heya_su=1&f_otona_su=1"
  end

  def search
    return nil if invalid? || !hotel.is_a?(Hotel)

    results = {}
    Charge.where(room_id: hotel.rooms.enabled.ids, plan_id: hotel.plans.enabled.ids, can_stay: true).within(start_day, finish_day).each do |f|
      if results[f.stay_day].nil?
        results[f.stay_day] = {
          url: build_plan_url(f.stay_day),
          start: DateTime.strptime(f.stay_day.to_s, '%Y%m%d').strftime('%Y-%m-%d'),
          min: f.amount,
          max: f.amount
        }
      else
        t = results[f.stay_day]
        t[:min] = t[:min] < f.amount ? t[:min] : f.amount
        t[:max] = t[:max] > f.amount ? t[:max] : f.amount
        results[f.stay_day] = t
      end
    end
    results
  end

  def start_day(format = true, refresh = false)
    if !defined?(@start_day) || refresh
      @start_day = DateTime.new(year.to_i, month.to_i, 1) - 1.weeks
    end
    format ? @start_day.strftime('%Y%m%d').to_i : @start_day
  end

  def finish_day(format = true, refresh = false)
    if !defined?(@finish_day) || refresh
      @finish_day = DateTime.new(year.to_i, month.to_i, 1).end_of_month + 2.weeks
    end
    format ? @finish_day.strftime('%Y%m%d').to_i : @finish_day
  end

  def persisted?
    false
  end
end