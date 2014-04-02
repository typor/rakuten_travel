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

  describe '#add_history' do
    let!(:charge) { create(:charge, hotel: hotel, room: room, plan: plan, amount: 1000, stay_day: 20140402, can_stay: true) }
    it { expect{ charge.add_history }.to change(ChargeHistory, :count).by(1) }
  end
end
