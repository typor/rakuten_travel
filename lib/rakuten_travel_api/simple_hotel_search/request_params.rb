module RakutenTravelApi
  module SimpleHotelSearch
    class RequestParams < ::RakutenTravelApi::Base::RequestParams
      VALID_NAMES = %w(largeClassCode middleClassCode smallClassCode detailClassCode page)

      # @override
      def valid_names
        @@valid_names ||= (VALID_NAMES + BASE_VALID_NAMES).freeze
      end
    end
  end
end