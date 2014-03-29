module RakutenTravelApi
  module VacantHotelSearch
    class RequestParams < ::RakutenTravelApi::Base::RequestParams
      VALID_NAMES = %w(largeClassCode middleClassCode smallClassCode detailClassCode hotelNo checkinDate checkoutDate maxCharge minCharge squeezeCondition carrier searchPattern page roomNum responseType datumType)

      # @override
      def valid_names
        @@valid_names ||= (VALID_NAMES + BASE_VALID_NAMES).freeze
      end
    end
  end
end