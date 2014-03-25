require 'spec_helper'

describe Hotel do
  describe '#from_api' do
    let(:response) {
      {
        "hotelNo" => "aaa",
        "hotelName" => "bbb",
        "postalCode" => "ccc",
        "address1" => "ddd",
        "address2" => "eee",
        "telephoneNo" => "fff",
        "access" => "ggg",
        "hotelImageUrl" => "hhh",
        "hotelInformationUrl" => "iii"
      }
    }
    subject(:hotel) { Hotel.new.from_api(response) }
    it { expect(hotel.no).to eq 'aaa' }
    it { expect(hotel.name).to eq 'bbb' }
    it { expect(hotel.postal_code).to eq 'ccc' }
    it { expect(hotel.address1).to eq 'ddd' }
    it { expect(hotel.address2).to eq 'eee' }
    it { expect(hotel.telephone_no).to eq 'fff' }
    it { expect(hotel.access).to eq 'ggg' }
    it { expect(hotel.image_url).to eq 'hhh' }
    it { expect(hotel.url).to eq 'iii' }
  end
end
