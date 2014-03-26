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

      def parse(data)
        code = data
      end
# {"middleClass"=>
#   [{"middleClassCode"=>"okinawa", "middleClassName"=>"沖縄県"},
#    {"smallClasses"=>
#      [{"smallClass"=>[{"smallClassCode"=>"nahashi", "smallClassName"=>"那覇"}]},
#       {"smallClass"=>
#         [{"smallClassCode"=>"hokubu", "smallClassName"=>"北部（恩納・名護・本部・今帰仁）"}]},
#       {"smallClass"=>
#         [{"smallClassCode"=>"chubu",
#           "smallClassName"=>"中部（宜野湾・北谷・沖縄・うるま・読谷）"}]},
#       {"smallClass"=>
#         [{"smallClassCode"=>"nanbu", "smallClassName"=>"南部（糸満・豊見城・南城）"}]},
#       {"smallClass"=>
#         [{"smallClassCode"=>"kerama",
#           "smallClassName"=>"慶良間諸島（渡嘉敷島・座間味島・阿嘉島）"}]},
#       {"smallClass"=>
#         [{"smallClassCode"=>"kumejima", "smallClassName"=>"久米島"}]},
#       {"smallClass"=>
#         [{"smallClassCode"=>"Miyako", "smallClassName"=>"宮古島・伊良部島"}]},
#       {"smallClass"=>
#         [{"smallClassCode"=>"ritou", "smallClassName"=>"石垣島・西表島・小浜島（八重山諸島）"}]},
#       {"smallClass"=>
#         [{"smallClassCode"=>"yonaguni", "smallClassName"=>"与那国島"}]},
#       {"smallClass"=>
#         [{"smallClassCode"=>"daito", "smallClassName"=>"大東島"}]}]}]}
      # x = { name: }
    end
  end
end