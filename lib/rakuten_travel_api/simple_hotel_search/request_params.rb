module RakutenTravelApi
  module SimpleHotelSearch
    class RequestParams < ::RakutenTravelApi::Base::RequestParams
      VALID_NAMES = %w(largeClassCode middleClassCode smallClassCode detailClassCode hotelNo latitude longitude searchRadius squeezeCondition carrier page hits datumType hotelThumbnailSize responseType sort allReturnFlag)

      # @override
      def valid_names
        @@valid_names ||= (VALID_NAMES + BASE_VALID_NAMES).freeze
      end
    end
  end
end