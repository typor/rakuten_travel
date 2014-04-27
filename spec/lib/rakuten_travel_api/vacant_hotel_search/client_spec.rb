require 'spec_helper'

describe RakutenTravelApi::VacantHotelSearch::Client do
  before(:all) do
    if RakutenApiSettings.application_id.nil?
      skip "Rakuten applicationId is not specified."
    end
  end

  let(:client) { RakutenTravelApi::VacantHotelSearch::Client.new(RakutenApiSettings.application_id, RakutenApiSettings.affiliate_id) }

  context 'simple case' do
    let(:response) {
      client.add_params(large_class_code: 'japan', middle_class_code: 'tokyo', small_class_code: 'tokyo', detail_class_code: 'D')
      VCR.use_cassette('vacant_hotel_search/' + client.parameter_digest) do
        client.request
      end
    }

    context 'response' do
      it { response.rooms }
      # it { expect(response).to be_kind_of(::RakutenTravelApi::VacantHotelSearch::Response) }
      # it { expect(response).to be_success }
      # it { expect(response.rooms.first['hotelNo']).to_not be_nil }
    end

  end
end