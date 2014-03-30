# HotelNoをキーに検索する
class Api::VacantApi
  attr_accessor :client
  def initialize(application_id, affiliate_id = nil)
    @client = RakutenTravelApi::VacantHotelSearch::Client.new(application_id, affiliate_id)
    @rooms = nil
    @room_cache = {}
  end

  def request(hotel, checkin)
    @rooms = do_call(hotel.id) do |client|
      client.request {|o|
        o.add_param :search_pattern, 1 # 宿泊プランごと
        o.add_param :hotel_no, hotel.no
        o.add_param :checkin_date, checkin.strftime('%Y-%m-%d')
        o.add_param :checkout_date, (checkin + 1.days).strftime('%Y-%m-%d')
      }
    end

    @rooms.compact
  end

  def do_call(hotel)
    response = yield @client if block_given?
    raise response.body.to_s unless response.success?

    response.rooms.map do |params|
      room = build_room(hotel, params)
      next if room.nil?
    end
    []
  end

  def build_room(hotel, params)
    code = params['roomClass']
    name = params['roomName']
    return nil if code.blank? || name.blank?
    return @room_cache[code] if @room_cache[code].presence

    room = Room.find_by(hotel_id: hotel.id, code: code)
    @room_cache[code] = room if room.presence

    # 喫煙可能かどうかは 【喫煙】の文字列で判定する
    smoking = name.include?('喫煙')
    room = Room.new(hotel: hotel, code: code, name: name, smoking: smoking)
    return nil unless room.save
    @room_cache[code] = room
  end
end