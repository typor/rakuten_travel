require 'spec_helper'

describe Plan do
  describe '#save' do
    let(:room) { create(:room) }
    let(:plan) { described_class.new(room: room, hotel: room.hotel, code: 1, name: 'foo', payment_code: 2, description: 'bar', point_rate: 99, with_dinner: true, with_breakfast: true) }
    it { expect{plan.save}.to change(Plan, :count).by(1) }
  end
end
