# HotelNoをキーに検索する
class Api::VacantApi

  def initialize(application_id, affiliate_id = nil)
    @client = RakutenTravelApi::VacantHotelSearch::Client.new(application_id, affiliate_id)
    @rooms = nil
  end

  def request(hotel, checkin)
    return @rooms if @rooms

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
      params['roomClass'].tapp
      params['roomName'].tapp
    end

  end

end