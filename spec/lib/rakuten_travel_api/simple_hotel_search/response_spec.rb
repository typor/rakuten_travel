require 'spec_helper'

describe RakutenTravelApi::SimpleHotelSearch::Response do
  before(:all) do
    if Settings.application_id.nil?
      pending "Rakuten applicationId is not specified."
    end
  end

  let(:client) { RakutenTravelApi::SimpleHotelSearch::Client.new(Settings.application_id, Settings.affiliate_id) }

  before {
    client.add_params(large_class_code: 'japan', middle_class_code: 'tokyo', small_class_code: 'tokyo', detail_class_code: 'D')
  }

  let(:response) {
    VCR.use_cassette('simple_hotel_search/' + client.parameter_digest) do
      client.request
    end
  }

  subject(:hotel) { response.hotels.first }
  it 'should have keys' do
    %w(hotelNo hotelName latitude longitude postalCode address1 address2 telephoneNo access hotelImageUrl hotelInformationUrl hotelRoomNum).each do |key|
      expect(subject).to be_key key
    end
  end
end