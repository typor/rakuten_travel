module RakutenTravelApi
  module VacantHotelSearch
    class Response < ::RakutenTravelApi::Base::Response
      attr_reader :page_count, :current_page

      def initialize(faraday_response = nil)
        super(faraday_response)
        @page_count = 0
        @current_page = 1
        if @body['pagingInfo']
          @page_count = @body['pagingInfo']['pageCount'].to_i
          @current_page = @body['pagingInfo']['page'].to_i
        end
      end

      def next?
        @page_count > 0 && @current_page < @page_count
      end

      def prev?
        @current_page > 1 && @page_count > 0
      end

      def rooms
        @rooms ||= get_rooms
      end

      def get_rooms
        return [] if error? || @body['hotels'].nil?
        [].tap do |results|
          @body['hotels'].each do |hotel|
            hotel_info = hotel['hotel'].shift['hotelBasicInfo']
            hotel_info.merge!(hotel['hotel'].shift['hotelDetailInfo'])
            hotel_info.merge!(hotel['hotel'].shift['hotelReserveInfo'])
            room = hotel['hotel'].first
            next unless room.key?('roomInfo')
            room['roomInfo'].map(&:values).flatten.each{|o| hotel_info.merge!(o)}
            results << hotel_info
          end
        end
      end

    end
  end
end