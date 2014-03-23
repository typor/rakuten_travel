require 'spec_helper'

describe RakutenTravelApi::SimpleHotelSearch do
  it do
    Settings.affiliate_id.tapp
    Settings.application_id.tapp
    client = RakutenTravelApi::SimpleHotelSearch.new(Settings.application_id, Settings.affiliate_id)
    VCR.use_cassette('simple_hotel_search_1') do
      response = client.request do |o|
        o.add_params(large_class_code: 'japan', middle_class_code: 'tokyo', small_class_code: 'tokyo', detail_class_code: 'D')
      end
      response.next?.tapp
      response.current_page.tapp
      response.page_count.tapp
    end
  end
end