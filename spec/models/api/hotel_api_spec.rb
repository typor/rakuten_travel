require 'spec_helper'

describe Api::HotelApi do
  let(:area) { create(:area, large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'D') }
  let(:api) { described_class.new(Settings.application_id) }

  describe '#request' do
    before(:all) do
      if Settings.application_id.nil?
        pending "Rakuten applicationId is not specified."
      end
    end

    subject(:response) {
      VCR.use_cassette('models/api/hotel_api/response') do
        api.request(area)
      end
    }

    it { expect(response).to be_kind_of Array }
    it { expect{response.first.save}.to change(Hotel, :count).by(1) }
  end

  describe '#build_hotel' do
    let(:params) {
      {
        "hotelNo"=>14112,
        "hotelName"=>"ホテルメッツ渋谷　東京",
        "hotelInformationUrl"=>"http://img.travel.rakuten.co.jp/image/tr/api/hs/dQ4dX/?f_no=14112",
        "planListUrl"=>"http://img.travel.rakuten.co.jp/image/tr/api/hs/cHNRi/?f_no=14112&f_flg=PLAN",
        "dpPlanListUrl"=>
        "http://img.travel.rakuten.co.jp/image/tr/api/hs/TDZXm/?noTomariHotel=14112",
        "reviewUrl"=>"http://img.travel.rakuten.co.jp/image/tr/api/hs/RmfmX/?f_hotel_no=14112",
        "hotelKanaName"=>"めっつ　しぶや　とうきょう",
        "hotelSpecial"=>"JR渋谷駅新南改札へは徒歩0分！ビジネスでのご利用はもちろん、観光スポットへのアクセスも抜群です！",
        "hotelMinCharge"=>5950,
        "latitude"=>35.655896,
        "longitude"=>139.70411,
        "postalCode"=>"150-0002",
        "address1"=>"東京都",
        "address2"=>"渋谷区渋谷3-29-17",
        "telephoneNo"=>"03-3409-0011",
        "faxNo"=>"03-3409-0023",
        "access"=>"JR渋谷駅【新南口】徒歩０分",
        "parkingInformation"=>"有、一泊につき￥2,000円（予約制）、全高・全幅制限有（フロントにお問い合わせ下さい）",
        "nearestStation"=>"渋谷",
        "hotelImageUrl"=>"http://img.travel.rakuten.co.jp/share/HOTEL/14112/14112.jpg",
        "hotelThumbnailUrl"=>"http://img.travel.rakuten.co.jp/HIMG/200/14112.jpg",
        "roomImageUrl"=> "http://img.travel.rakuten.co.jp/share/HOTEL/14112/14112_heya.jpg",
        "roomThumbnailUrl"=>"http://img.travel.rakuten.co.jp/HIMG/INTERIOR/14112.jpg",
        "hotelMapImageUrl"=>
        "http://img.travel.rakuten.co.jp/share/HOTEL/14112/14112map.gif",
        "reviewCount"=>2890,
        "reviewAverage"=>4.22,
        "userReview" => "dummy",
        "serviceAverage"=>3.99,
        "locationAverage"=>4.23,
        "roomAverage"=>4.24,
        "equipmentAverage"=>4.08,
        "bathAverage"=>3.99,
        "mealAverage"=>3.98,
        "reserveTelephoneNo"=>"050-2017-8989",
        "middleClassCode"=>"tokyo",
        "smallClassCode"=>"tokyo",
        "areaName"=>"東京２３区内",
        "hotelClassCode"=>"HOTEL",
        "checkinTime"=>"15:00",
        "checkoutTime"=>"11:00",
        "lastCheckinTime"=>"29:00",
        "hotelRoomNum"=>194
      }
    }
    subject(:hotel) { api.build_hotel(params) }
    it { expect(hotel.no).to eq 14112 }
    it { expect(hotel.meal_average).to eq 398 }
   end
end
