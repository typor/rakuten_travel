require 'spec_helper'

describe StopReservationWorker do
  let(:hotel) { create(:hotel) }
  let(:room) { create(:room, hotel: hotel) }
  let(:plan1) { create(:plan, hotel: hotel) }
  let(:plan2) { create(:plan, hotel: hotel) }
  let!(:charge1) { create(:charge, hotel: hotel, room: room, plan: plan1, can_stay: true, stay_day: 1.days.ago.strftime('%Y%m%d')) }
  let!(:charge2) { create(:charge, hotel: hotel, room: room, plan: plan2, can_stay: false, stay_day: 1.days.ago.strftime('%Y%m%d')) }
  let!(:charge3) { create(:charge, hotel: hotel, room: room, plan: plan1, can_stay: true, stay_day: 2.days.ago.strftime('%Y%m%d')) }
  let!(:charge4) { create(:charge, hotel: hotel, room: room, plan: plan1, can_stay: true, stay_day: 0.days.ago.strftime('%Y%m%d')) }

  before {
    expect{ described_class.new.perform }.to change(ChargeHistory, :count).by(1)
    charge1.reload
  }
  specify { expect(charge1.can_stay).to eq false }
end