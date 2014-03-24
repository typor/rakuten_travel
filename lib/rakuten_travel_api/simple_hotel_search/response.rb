module RakutenTravelApi
  module SimpleHotelSearch
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

      def hotels
        @hotels ||= get_hotels
      end

      def get_hotels
        return [] unless @body.key? 'hotels'
        hotels = []
        @body['hotels'].each do |hotel|
          next unless hotel.key? 'hotel'
          v = hotel['hotel'].first
          hotels << v['hotelBasicInfo']
        end
        hotels
      end
    end
  end
end