require 'spec_helper'

describe RakutenTravelApi::HotelDetailSearch::Client do
  before(:all) do
    if Settings.application_id.nil?
      pending "Rakuten applicationId is not specified."
    end
  end

  let(:client) { RakutenTravelApi::HotelDetailSearch::Client.new(Settings.application_id, Settings.affiliate_id) }

  context 'simple case' do
    let(:response) {
      VCR.use_cassette('hotel_detail_search/simple_case') do
        client.request do |o|
          o.add_params(hotel_no: 509)
        end
      end
    }

    context 'response' do
      it 'is a Response' do
        expect(response).to be_kind_of(::RakutenTravelApi::HotelDetailSearch::Response)
      end

      it 'is success' do
        expect(response).to be_success
      end

      subject(:hotel) { response.hotel }
      it { expect(hotel).to be_kind_of Hash }
      it { expect(hotel['hotelNo']).to eq 509 }
    end
  end

  context 'error' do
    let(:response) {
      VCR.use_cassette('hotel_detail_search/error') do
        client.request do |o|
          o.add_params(hotel_no: 1)
        end
      end
    }
    it { expect(response).to be_error }
  end
end