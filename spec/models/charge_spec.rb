require 'spec_helper'

describe Charge do
  let(:hotel) { create(:hotel) }
  let(:room) { create(:room, hotel: hotel) }
  let(:plan) { create(:plan, hotel: hotel) }

  describe '#save' do
    it 'should save' do
      model = described_class.new
      model.attributes = {
        hotel: hotel,
        room: room,
        plan: plan,
        amount: 1000,
        stay_day: 20140402,
        can_stay: true
      }
      expect { model.save }.to change(Charge, :count).by(1)
    end

    describe 'uniqueness validate' do
      let!(:charge) { described_class.create!(hotel: hotel, room: room, plan: plan, amount: 1000, stay_day: 20140402, can_stay: true) }
      it {
        model = described_class.new(hotel: hotel, room: room, plan: plan, amount: 1000, stay_day: 20140402, can_stay: false)
        expect { model.save }.to change(Charge, :count).by(0)
        expect(model.errors[:stay_day].size).to eq 1
      }
    end
  end

  describe '#same?' do
    let!(:charge) { create(:charge, hotel: hotel, room: room, plan: plan, amount: 1000, stay_day: 20140402, can_stay: true) }
    before {
      charge.add_history
    }
    it { expect(charge).to be_same }
    it 'amount' do
      charge.amount = 900
      expect(charge).to_not be_same
    end

    it 'can_stay' do
      charge.can_stay = false
      expect(charge).to_not be_same
    end

  end

  describe '#add_history' do
    let!(:charge) { create(:charge, hotel: hotel, room: room, plan: plan, amount: 1000, stay_day: 20140402, can_stay: true) }
    before {
      expect { charge.add_history }.to change(ChargeHistory, :count).by(1)
    }

    context 'found charge_history' do
      context 'same value' do
        it { expect { charge.add_history }.to change(ChargeHistory, :count).by(0) }
      end

      context 'not same value' do
        it do
          charge.amount = 900
          expect(charge).to_not be_same
          expect { charge.add_history }.to change(ChargeHistory, :count).by(1)
        end
      end
    end
  end

  describe '#within' do
    let!(:charge1) { create(:charge, hotel: hotel, room: room, plan: plan, stay_day: 20140401) }
    let!(:charge2) { create(:charge, hotel: hotel, room: room, plan: plan, stay_day: 20140402) }
    let!(:charge3) { create(:charge, hotel: hotel, room: room, plan: plan, stay_day: 20140403) }
    let!(:charge4) { create(:charge, hotel: hotel, room: room, plan: plan, stay_day: 20140404) }
    let!(:charge5) { create(:charge, hotel: hotel, room: room, plan: plan, stay_day: 20140405) }
    it { expect(Charge.within(20140402, 20140404).order(id: :asc).ids).to eq [charge2.id, charge3.id, charge4.id] }
  end

end
