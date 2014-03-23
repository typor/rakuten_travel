require_relative 'base/client'
require_relative 'base/params'
require_relative 'base/response'

module RakutenTravelApi
  class SimpleHotelSearch < ::RakutenTravelApi::Base::Client
    REQUEST_PATH = "https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20131024".freeze

    def initialize(application_id, affiliate_id = nil)
      super(REQUEST_PATH, application_id, affiliate_id)
    end

    def init_params(application_id, affiliate_id)
      @params = Params.new(application_id, affiliate_id)
    end

    def request
      yield @params if block_given?
      Response.new(get_request)
    end

    class Params < ::RakutenTravelApi::Base::Params
      VALID_NAMES = %w(largeClassCode middleClassCode smallClassCode detailClassCode).freeze

      def valid_names
        @@valid_names ||= (VALID_NAMES + BASE_VALID_NAMES).freeze
      end
    end

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