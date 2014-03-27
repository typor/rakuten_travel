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
            hotel['hotel'].each do |room|
              room_info = {}
              room['roomInfo'].map(&:values).flatten.each do |info|
                room_info.merge!(info)
              end
              results << hotel_info.merge(room_info)
            end
          end
        end
      end

    end
  end
end