module RakutenTravelApi
  module GetAreaClass
    class Response < ::RakutenTravelApi::Base::Response
      def initialize(faraday_response = nil)
        super(faraday_response)
      end

      def areas
        @areas ||= get_areas
      end

      def get_areas
        results = []
        areas = @body['areaClasses']['largeClasses'].first.values[0]
        large = areas.first
        areas.last['middleClasses'].each do |middle_areas|
          middle = middle_areas['middleClass'].first
          if middle_areas['middleClass'].last.nil?
            results << large.merge(middle)
            next
          end

          middle_areas['middleClass'].last['smallClasses'].each do |small_areas|
            small = small_areas['smallClass'].first
            unless small_areas['smallClass'][1].nil?
              small_areas['smallClass'].last['detailClasses'].each do |detail_areas|
                results << large.merge(middle).merge(small).merge(detail_areas['detailClass'])
              end
            else
              results << large.merge(middle).merge(small)
            end
          end
        end
        results
      end

    end
  end
end