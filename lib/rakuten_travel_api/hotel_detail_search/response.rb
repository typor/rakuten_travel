module RakutenTravelApi
  module HotelDetailSearch
    class Response < ::RakutenTravelApi::Base::Response

      def initialize(faraday_response = nil)
        super(faraday_response)
      end

      def hotel
        hotels.first
      end

      def hotels
        @hotels ||= get_hotels
      end

      def get_hotels
        return [] if @body.nil? || !@body.key?('hotels')
        hotels = []
        @body['hotels'].each do |hotel|
          tmp = {}
          hotel['hotel'].each do |f|
            f.each_pair do |k,v|
              tmp.merge!(v)
            end
          end
          hotels << tmp
        end
        hotels
      end
    end
  end
end