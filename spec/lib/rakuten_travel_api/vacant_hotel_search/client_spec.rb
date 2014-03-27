require 'spec_helper'

describe RakutenTravelApi::VacantHotelSearch::Client do
  before(:all) do
    if Settings.application_id.nil?
      pending "Rakuten applicationId is not specified."
    end
  end

  let(:client) { RakutenTravelApi::VacantHotelSearch::Client.new(Settings.application_id, Settings.affiliate_id) }

  context 'simple case' do
    let(:response) {
      VCR.use_cassette('vacant_hotel_search/simple_case') do
        client.request do |o|
          o.add_params(large_class_code: 'japan', middle_class_code: 'tokyo', small_class_code: 'tokyo', detail_class_code: 'D')
        end
      end
    }

    context 'response' do
      it { expect(response).to be_kind_of(::RakutenTravelApi::VacantHotelSearch::Response) }
      it { expect(response).to be_success }
      it { expect(response.rooms.first['hotelNo']).to_not be_nil }
    end

  end
end