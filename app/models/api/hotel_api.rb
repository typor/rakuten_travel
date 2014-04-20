class Api::HotelApi
  def initialize(application_id, affiliate_id = nil)
    @application_id = application_id
    @affiliate_id = affiliate_id
    @client = nil
  end

  def api_client(refresh = false)
    if refresh || @client.nil?
      @client = RakutenTravelApi::SimpleHotelSearch::Client.new(@application_id, @affiliate_id)
    end
    @client
  end

  def request(area)
    hotels = do_call(area.id) do |client|
      client.request {|o| o.add_params area.to_api_params }
    end

    while api_client.next?
      hotels += do_call(area.id) {|client| client.next}
    end
    hotels.compact
  end

  def do_call(area_id)
    response = block_given? ? (yield api_client) : api_client.request
    unless response.success?
      Rails.logger.error "[#{@client.id}] Response error" + @response.body.to_s
      return []
    end

    response.hotels.map do |params|
      build_hotel(params.merge(area_id: area_id))
    end
  end

  def build_hotel(params)
    attributes = {}
    params.each_pair do |k, v|
      if valid_keys.key?(k)
        attributes[valid_keys[k]] = v
      elsif review_keys.key?(k)
        attributes[review_keys[k]] = v.present? ? v.to_f * 100 : 0
      end
    end

    return nil unless attributes.key? :no
    attributes[:description] = build_description(params).tapp

    (Hotel.find_by(no: attributes[:no]) || Hotel.new).tap do |o|
      o.attributes = attributes
    end
  end

  def valid_keys
    @@valid_keys ||= {
      'hotelNo' => :no,
      'hotelName' => :long_name,
      'postalCode' => :postal_code,
      'address1' => :address1,
      'address2' => :address2,
      'telephoneNo' => :telephone_no,
      'access' => :access,
      'hotelImageUrl' => :hotel_image_url,
      'roomImageUrl' => :room_image_url,
      'hotelInformationUrl' => :url,
      'latitude' => :latitude,
      'longitude' => :longitude,
      'hotelRoomNum' => :room_num,
      'reviewUrl' => :review_url,
      'reviewCount' => :review_count,
      area_id: :area_id
    }.freeze
  end

  # review用のキー
  def review_keys
    @@review_keys ||= {
      'reviewAverage' => :review_average,
      'serviceAverage' => :service_average,
      'locationAverage' => :location_average,
      'roomAverage' => :room_average,
      'equipmentAverage' => :equipment_average,
      'bathAverage' => :bath_average,
      'mealAverage' => :meal_average
    }.freeze
  end

  def build_description(params)
    texts = []
    texts << "Point: " + params['hotelSpecial']
    texts << "駐車場: " + params['parkingInformation'] if params['parkingInformation'].present?
    texts << "チェックイン: " + params['checkinTime'] if params['checkinTime'].present?
    texts << "最終チェックイン: " + params['lastCheckinTime'] if params['lastCheckinTime'].present?
    texts << "チェックアウト: " + params['checkoutTime'] if params['checkoutTime'].present?
    texts.join("\n").gsub(/\r\n?/, "\n")
  end
end