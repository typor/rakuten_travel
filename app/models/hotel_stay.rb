class HotelStay
  include ActiveModel::Conversion
  include ActiveModel::Validations
  extend ActiveModel::Naming

  PLAN_URL_BASE = "http://hotel.travel.rakuten.co.jp/hotelinfo/plan/"
  AFFILIATE_URL_BASE = "http://hb.afl.rakuten.co.jp/hgc/"
  EXPIRES = 30.minutes

  attr_accessor :hotel, :year, :month, :smoking, :gender

  validates :hotel, presence: true
  validates :year, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 2014, less_than: 2030 }
  validates :month, presence: true, numericality: {only_integer: true, greater_than: 0, less_than: 13 }
  validates_inclusion_of :smoking, :gender, in: [0, 1, 2]

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    @smoking ||= 0
    @gender ||= 0
  end

  def search
    return {} if invalid? || !hotel.is_a?(Hotel)
    cache = read_cache
    return cache if cache

    results = {}
    Charge.where(room_id: room_ids, plan_id: plan_ids, can_stay: true).within(start_day, finish_day).each do |f|
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

    Rails.cache.write cache_name, results, expires_in: EXPIRES if perform_caching?
    results
  end

  def room_ids
    return [] unless hotel.is_a? Hotel

    relation = hotel.rooms.enabled
    if @smoking == 1
      relation = relation.smoking
    elsif @smoking == 2
      relation = relation.nonsmoking
    end

    if @gender == 1
      relation = relation.notladis
    elsif @gender == 2
      relation = relation.ladies
    end
    relation.order(id: :asc).ids
  end

  def plan_ids
    hotel.plans.enabled.ids
  end

  def build_plan_url(stay_day, span = 1)
    url = plan_url(stay_day, span)
    return url if RakutenApiSettings.affiliate_id.blank?
    AFFILIATE_URL_BASE + RakutenApiSettings.affiliate_id + "/?pc=" + CGI.escape(url)
  end

  def plan_url(stay_day, span, params = {})
    start = DateTime.strptime(stay_day.to_s, '%Y%m%d')
    finish = start + span.days
    params = plan_url_params(start, finish).merge(params)
    PLAN_URL_BASE + "#{hotel.no}?#{params.to_query}"
  end

  def plan_url_params(start, finish)
    {
      f_nen1: start.year,
      f_tuki1: start.month,
      f_hi1: start.day,
      f_nen2: finish.year,
      f_tuki2: finish.month,
      f_hi2: finish.day,
      f_heya_su: 1,
      f_otona_su: 1
    }
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

  def to_params
    {
      hotel_id: @hotel.id,
      year: @year,
      month: @month,
      smoking: @smoking,
      gender: @gender
    }
  end

  def cache_name
    self.class.to_s + '-' + to_params.map{|k,v| "#{k}_#{v}" }.join('-')
  end

  def perform_caching?
    Rails.configuration.action_controller.perform_caching
  end

  def read_cache
    return nil unless perform_caching?
    Rails.cache.read(cache_name)
  end

  def persisted?
    false
  end

end