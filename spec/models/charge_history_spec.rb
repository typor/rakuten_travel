require 'spec_helper'

describe ChargeHistory do
  let(:hotel) { create(:hotel) }
  let(:room) { create(:room, hotel: hotel) }
  let(:plan) { create(:plan, hotel: hotel) }
  let(:charge) { create(:charge, hotel: hotel, room: room, plan: plan) }
  describe '#save' do
    it 'should save' do
      model = described_class.new
      model.charge_id = charge.id
      model.amount = 1000
      model.researched_at = '2014-04-02 00:00:00'
      expect { model.save }.to change(ChargeHistory, :count).by(1)
    end
  end
end
