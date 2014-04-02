# HotelNoをキーに検索する
class Api::VacantApi
  attr_accessor :client

  def initialize(application_id, affiliate_id = nil)
    @client = RakutenTravelApi::VacantHotelSearch::Client.new(application_id, affiliate_id)
    @rooms = nil
    @room_cache = {}
    @plan_cache = {}
  end

  def request(hotel, start)
    @charges = do_call(hotel) do |client|
      client.request {|o|
        o.add_param :search_pattern, 1 # 宿泊プランごと
        o.add_param :hotel_no, hotel.no
        o.add_param :checkin_date, start.to_i.days.since.strftime('%Y-%m-%d')
        o.add_param :checkout_date, (start.to_i + 1).days.since.strftime('%Y-%m-%d')
      }
    end

    while @client.next?
      @charges += do_call(hotel) {|client| client.next}
    end

    @charges.compact
  end

  def do_call(hotel)
    response = block_given? ? (yield @client) : @client.request
    @requested = 0.days.since.strftime('%Y-%m-%d %H:%M:%S')

    # @todo 部屋が完全にない場合と、エラーの場合で分けて処理する
    raise response.body.to_s unless response.success?

    response.rooms.map do |params|
      build!(hotel, params)
    end
  end

  def build!(hotel, params)
    room = build_room(hotel.id, params)
    raise "Failure creating room object" if room.nil?

    plan = build_plan(hotel.id, params)
    raise "Failure creating plan object" if plan.nil?

    charge = build_charge(hotel.id, room.id, plan.id, params)
    raise "Failure creating charge object" if charge.nil?

    charge.add_history(@requested)
    charge
  rescue Exception => e
    # todo log
    puts e.message
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
      name: name,
      smoking: name.include?('喫煙') # 喫煙可能かどうかは 【喫煙】の文字列で判定する
    }
    if room.save
      @room_cache[code] = room
    else
      nil
    end
  end

  def build_plan(hotel_id, params)
    code = params['planId']
    return nil if code.blank?
    return @plan_cache[code] if @plan_cache[code].present?

    plan = Plan.find_by(hotel_id: hotel_id, code: code) || Plan.new

    plan.attributes = {
      hotel_id: hotel_id,
      code: code,
      long_name: params['planName'],
      point_rate: params['pointRate'],
      with_dinner: params['withDinnerFlag'],
      with_breakfast: params['withBreakfastFlag'],
      payment_code: params['payment'].to_i,
      description: params['planContents']
    }

    if plan.save
      @plan_cache[code] = plan
    else
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
      can_stay: true
    }

    if charge.save
      charge
    else
      puts charge.errors.full_messages
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