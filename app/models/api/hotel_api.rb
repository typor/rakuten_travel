class Api::HotelApi
  MAP = {
    'hotelNo' => :no,
    'hotelName' => :long_name,
    'postalCode' => :postal_code,
    'address1' => :address1,
    'address2' => :address2,
    'telephoneNo' => :telephone_no,
    'access' => :access,
    'hotelImageUrl' => :image_url,
    'hotelInformationUrl' => :url,
    'latitude' => :latitude,
    'longitude' => :longitude,
    'hotelRoomNum' => :room_num,
    area_id: :area_id
  }.freeze

  def initialize(application_id, affiliate_id = nil)
    @client = RakutenTravelApi::SimpleHotelSearch::Client.new(application_id, affiliate_id)
    @hotels = nil
  end

  def request(area)
    return @hotels if @hotels

    @hotels = api_call(area.id) do |client|
      client.request {|o| o.add_params area.to_api_params }
    end

    while @client.next?
      @hotels += api_call(area.id) {|client| client.next}
    end
    @hotels.compact
  end

  def api_call(area_id)
    response = yield @client if block_given?
    raise response.body.to_s unless response.success?

    response.hotels.map do |params|
      to_hotel(params.merge(area_id: area_id))
    end

  end

  def to_hotel(params)
    attributes = {}
    params.each_pair do |k, v|
      attributes[MAP[k]] = v if MAP.key? k
    end

    return nil unless attributes.key? :no

    hotel = Hotel.find_by(no: attributes[:no])
    hotel ||= Hotel.new
    hotel.attributes = attributes
    hotel
  end

end