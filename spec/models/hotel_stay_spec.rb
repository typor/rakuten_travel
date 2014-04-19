require 'spec_helper'

describe HotelStay do
  let(:hotel) { create(:hotel) }

  describe '#stay_day' do
    let(:my) { described_class.new(hotel: hotel, year: 2014, month: 9) }
    it { expect(my.start_day).to eq 20140901 }
    it { expect(my.finish_day).to eq 20140930 }
  end

  describe '#search' do
    context 'invalid' do
      it { expect(described_class.new.search).to be_nil }
    end

    let!(:room1) { create(:room, hotel: hotel, enabled: true) }
    let!(:room2) { create(:room, hotel: hotel, enabled: false) }
    let!(:plan1) { create(:plan, hotel: hotel, enabled: true) }
    let!(:plan2) { create(:plan, hotel: hotel, enabled: false) }
    let!(:charge1) { create(:charge, hotel: hotel, room: room1, plan: plan1, can_stay: true, amount: 1000, stay_day: '20141001') }
    let!(:charge2) { create(:charge, hotel: hotel, room: room1, plan: plan1, can_stay: true, amount: 2000, stay_day: '20141002') }

    it do
      klass = described_class.new(hotel: hotel, year: 2014, month: 10)
      expect(klass.search)
    end
  end

  describe 'validation' do
    subject(:klass) { described_class.new }
    it { expect(klass).to validate_presence_of(:hotel) }
    it { expect(klass).to validate_presence_of(:year) }
    it { expect(klass).to validate_presence_of(:month) }
    it { expect(klass).to validate_numericality_of(:year).is_greater_than_or_equal_to(2014) }
    it { expect(klass).to validate_numericality_of(:month).is_greater_than(0) }
    it { expect(klass).to validate_numericality_of(:month).is_less_than(13) }
  end
end