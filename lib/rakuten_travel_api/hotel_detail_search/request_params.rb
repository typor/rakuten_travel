module RakutenTravelApi
  module HotelDetailSearch
    class RequestParams < ::RakutenTravelApi::Base::RequestParams
      VALID_NAMES = %w(hotelNo carrier datumType hotelThumbnailSize responseType)

      # @override
      def valid_names
        @@valid_names ||= (VALID_NAMES + BASE_VALID_NAMES).freeze
      end
    end
  end
end