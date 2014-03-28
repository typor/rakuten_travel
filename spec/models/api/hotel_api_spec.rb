require 'spec_helper'

describe Api::HotelApi do
  let(:area) { create(:area, large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'D') }
  describe '#request' do
    before(:all) do
      if Settings.application_id.nil?
        pending "Rakuten applicationId is not specified."
      end
    end

    let(:api) { described_class.new(Settings.application_id) }
    subject(:response) {
      VCR.use_cassette('models/api/hotel_api/response') do
        api.request(area)
      end
    }

    it { expect(response).to be_kind_of Array }
    it { expect(response.first).to be_kind_of Hotel }
  end

  # describe '#from_api' do
  #   let(:response) {
  #     {
  #       "hotelNo" => "aaa",
  #       "hotelName" => "bbb",
  #       "postalCode" => "ccc",
  #       "address1" => "ddd",
  #       "address2" => "eee",
  #       "telephoneNo" => "fff",
  #       "access" => "ggg",
  #       "hotelImageUrl" => "hhh",
  #       "hotelInformationUrl" => "iii"
  #     }
  #   }
  #   subject(:hotel) { Hotel.new.from_api(response) }
  #   it { expect(hotel.no).to eq 'aaa' }
  #   it { expect(hotel.name).to eq 'bbb' }
  #   it { expect(hotel.postal_code).to eq 'ccc' }
  #   it { expect(hotel.address1).to eq 'ddd' }
  #   it { expect(hotel.address2).to eq 'eee' }
  #   it { expect(hotel.telephone_no).to eq 'fff' }
  #   it { expect(hotel.access).to eq 'ggg' }
  #   it { expect(hotel.image_url).to eq 'hhh' }
  #   it { expect(hotel.url).to eq 'iii' }
  # end
end
