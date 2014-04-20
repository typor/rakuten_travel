require 'spec_helper'

describe HotelStay do
  let(:hotel) { create(:hotel) }

  describe '#stay_day' do
    let(:my) { described_class.new(hotel: hotel, year: 2014, month: 9) }
    it { expect(my.start_day).to eq((DateTime.new(2014, 9, 1) - 1.weeks).strftime('%Y%m%d').to_i) }
    it { expect(my.finish_day).to eq((DateTime.new(2014, 9, 1).end_of_month + 2.weeks).strftime('%Y%m%d').to_i) }
  end

  describe '#search' do
    context 'invalid' do
      it { expect(described_class.new.search).to be_nil }
    end

    let!(:room1) { create(:room, hotel: hotel, enabled: true) }
    let!(:room2) { create(:room, hotel: hotel, enabled: true) }
    let!(:plan1) { create(:plan, hotel: hotel, enabled: true) }
    let!(:plan2) { create(:plan, hotel: hotel, enabled: true) }
    let!(:charge1) { create(:charge, hotel: hotel, room: room1, plan: plan1, can_stay: true, amount: 100, stay_day: '20141001') }
    let!(:charge2) { create(:charge, hotel: hotel, room: room2, plan: plan1, can_stay: true, amount: 200, stay_day: '20141001') }
    let!(:charge3) { create(:charge, hotel: hotel, room: room1, plan: plan1, can_stay: true, amount: 1000, stay_day: '20141002') }
    let!(:charge4) { create(:charge, hotel: hotel, room: room2, plan: plan1, can_stay: true, amount: 2000, stay_day: '20141002') }

    subject(:response) { described_class.new(hotel: hotel, year: 2014, month: 10).search }
    it { expect(subject).to be_key 20141001 }
    it { expect(subject).to be_key 20141002 }

    context '20141001' do
      subject(:my) { response[20141001] }
      it {
        expect(my[:min]).to eq 100
        expect(my[:max]).to eq 200
        expect(my[:start]).to eq '2014-10-01'
      }
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