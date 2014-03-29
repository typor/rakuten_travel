require 'spec_helper'

describe RakutenTravelApi::VacantHotelSearch::Response do
  before(:all) do
    if Settings.application_id.nil?
      pending "Rakuten applicationId is not specified."
    end
  end

  let(:client) { RakutenTravelApi::VacantHotelSearch::Client.new(Settings.application_id, Settings.affiliate_id) }

  context 'simple case' do
    before {
      client.add_params(large_class_code: 'japan', middle_class_code: 'tokyo', small_class_code: 'tokyo', detail_class_code: 'D', checkin_date: 30.days.since.strftime('%Y-%m-%d'), checkout_date: 31.days.since.strftime('%Y-%m-%d'))
    }

    subject(:response) {
      VCR.use_cassette('vacant_hotel_search/' + client.parameter_digest) do
        client.request
      end
    }

    it { expect(response).to be_kind_of(::RakutenTravelApi::VacantHotelSearch::Response) }
    it { expect(response).to be_success }
    it { expect(response.rooms).to be_kind_of Array }
    context 'room' do
      subject(:room) { response.rooms.first }
      it {
        room.tapp
        expect(room).to be_key 'total'
        expect(room).to be_key 'hotelNo'
        expect(room).to be_key 'roomClass'
      }
    end

  end
end