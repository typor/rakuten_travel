require 'spec_helper'

describe Plan do
  describe '#save' do
    let(:room) { create(:room) }
    let(:plan) { described_class.new(hotel: room.hotel, code: 1, long_name: 'foo', payment_code: 2, description: 'bar', point_rate: 99, with_dinner: true, with_breakfast: true) }
    it { expect{plan.save}.to change(Plan, :count).by(1) }
  end

  describe '.payment_codes' do
    subject(:payment_codes) { Plan.payment_codes }
    it { expect(payment_codes).to eq({'現金のみ' => 0, 'カードのみ' => 1, '現金/カード' => 2}) }
  end

  describe '.safe_keys' do
    subject(:safe_keys) { Plan.safe_keys }
    it { expect(safe_keys.size).to eq 9 }
    it { expect(safe_keys).to be_include 'hotel_id' }
    it { expect(safe_keys).to be_include 'code' }
    it { expect(safe_keys).to be_include 'long_name' }
    it { expect(safe_keys).to be_include 'short_name' }
    it { expect(safe_keys).to be_include 'payment_code' }
    it { expect(safe_keys).to be_include 'description' }
    it { expect(safe_keys).to be_include 'point_rate' }
    it { expect(safe_keys).to be_include 'with_dinner' }
    it { expect(safe_keys).to be_include 'with_breakfast' }
  end
end
