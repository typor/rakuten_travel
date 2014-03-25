module RakutenTravelApi
  module HotelDetailSearch
    class Client < ::RakutenTravelApi::Base::Client
      REQUEST_PATH = "/services/api/Travel/HotelDetailSearch/20131024".freeze
      attr_reader :response

      def initialize(application_id, affiliate_id = nil)
        super(REQUEST_PATH, application_id, affiliate_id)
      end

      def init_params(application_id, affiliate_id)
        @params = ::RakutenTravelApi::HotelDetailSearch::RequestParams.new(application_id, affiliate_id)
      end

      def request
        yield @params if block_given?
        if valid
          @response = ::RakutenTravelApi::HotelDetailSearch::Response.new(get_request)
        else
          raise ArgumentError.new('hotelNo is required')
        end
      end

      def valid
        @params.has?('hotel_no')
      end

    end
  end
end