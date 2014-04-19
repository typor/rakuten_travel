require 'spec_helper'

describe Hotel do
  describe '#save' do
    it '保存できること' do
      expect {
        described_class.create(area: create(:area), no: '123', long_name: 'foo', postal_code: '123-4567', address1: 'foo', address2: 'bar', telephone_no: '03-1111-2222', access: 'baz', hotel_image_url: 'http://foo.com/', url: 'http://bar.com/')
      }.to change{Hotel.count}.by(1)
    end
  end

  describe '#safe_keys' do
    subject(:safe_keys) { described_class.safe_keys }
    it { expect(safe_keys).to_not be_include('created_at') }
    it { expect(safe_keys).to_not be_include('id') }
    it { expect(safe_keys).to_not be_include('updated_at') }
    it { expect(safe_keys).to be_include('area_id') }
  end

  describe '#smoking_rooms' do
    let(:hotel) { create(:hotel) }
    let!(:room1) { create(:room, hotel: hotel, enabled: true, smoking: true) }
    let!(:room2) { create(:room, hotel: hotel, enabled: true, smoking: false) }
    let!(:room3) { create(:room, hotel: hotel, enabled: false, smoking: true) }
    let!(:room4) { create(:room, hotel: hotel, enabled: true, smoking: true) }
    it { expect(hotel.smoking_rooms.order(id: :asc)).to eq [room1, room4] }
  end

  describe '#nonsmoking_rooms' do
    let(:hotel) { create(:hotel) }
    let!(:room1) { create(:room, hotel: hotel, enabled: true, smoking: false) }
    let!(:room2) { create(:room, hotel: hotel, enabled: true, smoking: true) }
    let!(:room3) { create(:room, hotel: hotel, enabled: false, smoking: false) }
    let!(:room4) { create(:room, hotel: hotel, enabled: true, smoking: false) }
    it { expect(hotel.nonsmoking_rooms.order(id: :asc)).to eq [room1, room4] }
  end

  describe '#ladies_rooms' do
    let(:hotel) { create(:hotel) }
    let!(:room1) { create(:room, hotel: hotel, enabled: true, ladies: true) }
    let!(:room2) { create(:room, hotel: hotel, enabled: true, ladies: false) }
    let!(:room3) { create(:room, hotel: hotel, enabled: false, ladies: true) }
    let!(:room4) { create(:room, hotel: hotel, enabled: true, ladies: true) }
    it { expect(hotel.ladies_rooms.order(id: :asc)).to eq [room1, room4] }
  end
end
