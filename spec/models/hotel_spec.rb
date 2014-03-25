require 'spec_helper'

describe Hotel do
  describe '#save' do
    it '保存できること' do
      expect {
        described_class.create(area: create(:area), no: '123', name: 'foo', postal_code: '123-4567', address1: 'foo', address2: 'bar', telephone_no: '03-1111-2222', access: 'baz', image_url: 'http://foo.com/', url: 'http://bar.com/')
      }.to change{Hotel.count}.by(1)
    end
  end

  describe '#safe_keys' do
    subject(:safe_keys) { described_class.new.safe_keys }
    it { expect(safe_keys).to_not be_include('created_at') }
    it { expect(safe_keys).to be_include('area_id') }
  end

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
