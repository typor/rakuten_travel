require 'spec_helper'

describe Room do
  describe 'validation' do
    subject(:klass) { described_class.new }
    it { expect(klass).to validate_presence_of(:hotel_id) }
    it { expect(klass).to validate_presence_of(:code) }
    it { expect(klass).to validate_presence_of(:long_name) }
    it { expect(klass).to ensure_length_of(:code).is_at_most(32) }
    it { expect(klass).to ensure_length_of(:long_name).is_at_most(255) }

    describe 'uniqueness' do
      let!(:room) { create(:room) }
      let(:my_room) { build(:room, code: room.code, hotel_id: room.hotel_id) }
      it { expect(my_room).to have(1).errors_on(:code) }
      context 'not same hotel id' do
        before { my_room.hotel_id = my_room.hotel_id + 1 }
        it { expect(my_room).to have(0).errors_on(:code) }
      end
    end

    describe 'smoking' do
      it {
        [true, false, 0, 1].each do |f|
          expect(described_class.new(smoking: f)).to have(0).errors_on(:smoking)
        end
      }
      it {
        [nil, ''].each do |f|
          expect(described_class.new(smoking: f)).to have(1).errors_on(:smoking)
        end
      }
    end
  end

  describe '.safe_keys' do
    subject(:safe_keys) { described_class.safe_keys }
    let(:valid_keys) { %w(hotel_id code long_name short_name smoking ladies enabled) }
    it {
      expect(safe_keys.size).to eq valid_keys.size
      valid_keys.each do |key|
        expect(safe_keys).to be_include key
      end
    }
  end
end
