# HotelNoをキーに検索する
class Api::VacantApi
  attr_accessor :client, :hotel

  def initialize(hotel, application_id, affiliate_id = nil)
    @application_id = application_id
    @affiliate_id = affiliate_id
    @api_client = nil
    @hotel = hotel
    clear_cache
  end

  def requested_at
    @requested_at ||= 0.days.since.strftime('%Y-%m-%d %H:%M:%S')
  end

  def api_client(refresh = false)
    if refresh || @api_client.nil?
      @api_client = RakutenTravelApi::VacantHotelSearch::Client.new(@application_id, @affiliate_id)
    end
    @api_client
  end

  def clear_cache
    @room_cache = {}
    @plan_cache = {}
  end

  def request(checkin, checkout = nil)
    checkout ||= (checkin + 1)
    stay_day = checkin.to_i.days.since.strftime('%Y%m%d')

    before_request(@hotel.id, stay_day)
    charges = do_call do |client|
      client.request {|o|
        o.add_param :page, nil
        o.add_param :hotel_no, @hotel.no
        o.add_param :checkin_date, checkin.to_i.days.since.strftime('%Y-%m-%d')
        o.add_param :checkout_date, checkout.to_i.days.since.strftime('%Y-%m-%d')
      }
    end

    while api_client.next?
      charges += do_call {|client| client.next}
    end
    after_request(@hotel.id, stay_day)

    charges.compact
  rescue Exception => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join("\n")
    []
  end

  def before_request(hotel_id, stay_day)
    # marked target charge data
    Charge.where(hotel_id: hotel_id, stay_day: stay_day).update_all(executed: false)
    requested_at
  end

  def after_request(hotel_id, stay_day)
    # unmarked target charge data
    Charge.where(hotel_id: hotel_id, stay_day: stay_day, executed: false).each do |charge|
      charge.update(executed: true, can_stay: false)
      charge.add_history(requested_at)
    end
  end

  def do_call
    response = block_given? ? (yield api_client) : api_client.request
    if response.error?
      if response.not_found?
        Rails.logger.info "VacantApi record not found"
        return
      else
        raise response.body.to_s
      end
    end

    response.rooms.map do |params|
      build!(params)
    end
  end

  def build!(params)
    room = build_room(@hotel.id, params)
    raise "Failure creating room object" if room.nil?

    plan = build_plan(@hotel.id, params)
    raise "Failure creating plan object" if plan.nil?

    charge = build_charge(@hotel.id, room.id, plan.id, params)
    raise "Failure creating charge object" if charge.nil?

    charge.add_history(requested_at)
    charge
  rescue Exception => e
    Rails.logger.error e.message
    nil
  end

  def build_room(hotel_id, params)
    code = params['roomClass']
    name = params['roomName']
    return nil if code.blank? || name.blank?
    return @room_cache[code] if @room_cache[code].present?

    room = Room.find_by(hotel_id: hotel_id, code: code) || Room.new
    room.attributes = {
      hotel_id: hotel_id,
      code: code,
      long_name: name,
      smoking: name.include?('喫煙'), # 喫煙可能かどうかは 【喫煙】の文字列で判定する
      ladies: name.include?('レディース') || name.include?('レディス')
    }
    if room.save
      @room_cache[code] = room
    else
      Rails.logger.error(room.errors.full_messages)
      nil
    end
  end

  def build_plan(hotel_id, params)
    code = params['planId']
    return nil if code.blank?
    return @plan_cache[code] if @plan_cache[code].present?

    plan = Plan.find_by(hotel_id: hotel_id, code: code) || Plan.new
    name = params['planName']
    gift = Plan.parse_gift(name)

    plan.attributes = gift.merge({
      hotel_id: hotel_id,
      code: code,
      long_name: name,
      point_rate: params['pointRate'],
      with_dinner: params['withDinnerFlag'],
      with_breakfast: params['withBreakfastFlag'],
      payment_code: params['payment'].to_i,
      description: params['planContents']
    })

    if plan.save
      @plan_cache[code] = plan
    else
      Rails.logger.error(plan.errors.full_messages)
      nil
    end
  end

  def build_charge(hotel_id, room_id, plan_id, params)
    stay_day = parse_date(params['stayDate'])
    amount = params['total']
    return false if stay_day.nil? || amount.nil?

    charge = Charge.find_by(room_id: room_id, plan_id: plan_id, stay_day: stay_day) || Charge.new
    charge.attributes = {
      hotel_id: hotel_id,
      room_id: room_id,
      plan_id: plan_id,
      stay_day: stay_day,
      amount: amount,
      can_stay: true,
      executed: true
    }

    if charge.save
      charge
    else
      Rails.logger.error(charge.errors.full_messages)
      nil
    end
  end

  def parse_date(d)
    return nil if d.nil?
    Date.strptime(d, '%Y-%m-%d').strftime('%Y%m%d').to_i
  rescue
    nil
  end

end