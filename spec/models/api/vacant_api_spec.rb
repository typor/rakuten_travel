require 'spec_helper'

describe Api::VacantApi do
  before(:all) do
    if Settings.application_id.nil?
      pending "Rakuten applicationId is not specified."
    end
  end

  let(:hotel) { create(:hotel, no: '163') }
  let(:api) { described_class.new(hotel, Settings.application_id) }
  describe '#request' do
    let(:checkin) { 10 }
    let(:vcr_name) { 'models/api/vacant_api/' + hotel.no + '_' + checkin.days.since.strftime('%Y%m%d') }
    subject(:response) {
      VCR.use_cassette(vcr_name) do
        api.request(checkin)
      end
    }

    it { expect(response.size).to be > 0 }
  end

  describe '#before_request, #after_request' do
    let!(:room) { create(:room, hotel: hotel) }
    let!(:plan_1) { create(:plan, hotel: hotel) }
    let!(:plan_2) { create(:plan, hotel: hotel) }
    let!(:charge_1_1) { create(:charge, hotel: hotel, room: room, plan: plan_1, stay_day: 20140401, can_stay: true, executed: true) }
    let!(:charge_1_2) { create(:charge, hotel: hotel, room: room, plan: plan_1, stay_day: 20140402, can_stay: true, executed: true) }
    let!(:charge_2_1) { create(:charge, hotel: hotel, room: room, plan: plan_2, stay_day: 20140401, can_stay: true, executed: true) }
    let!(:charge_2_2) { create(:charge, hotel: hotel, room: room, plan: plan_2, stay_day: 20140402, can_stay: true, executed: true) }

    before {
      api.before_request(hotel.id, 20140401)
    }
    it '該当日付の executed が falseになること' do
      expect(charge_1_1.reload.executed).to eq false
      expect(charge_1_2.reload.executed).to eq true
      expect(charge_2_1.reload.executed).to eq false
      expect(charge_2_2.reload.executed).to eq true
    end

    describe '#after_request' do
      before {
        expect{ api.after_request(hotel.id, 20140401) }.to change(ChargeHistory, :count).by(2)
      }
      it 'executedがtrueになり、can_stayがfalseになること' do
        charge_1_1.reload
        expect(charge_1_1.executed).to eq true
        expect(charge_1_1.can_stay).to eq false
        charge_2_1.reload
        expect(charge_2_1.executed).to eq true
        expect(charge_2_1.can_stay).to eq false
      end
    end
  end

  describe '#build_plan' do
    let(:params) {
      {
       "planId" => 10000,
       "planName" => "宿泊プラン【朝食付】",
       "pointRate" => 10,
       "withDinnerFlag" => 0,
       "withBreakfastFlag" => 1,
       "payment" => "1",
       "planContents" => 'foo'
      }
    }
    it { expect { api.build_plan(hotel.id, params) }.to change(Plan, :count).by(1) }

    context 'attributes' do
      subject(:plan) { api.build_plan(hotel.id, params) }
      it do
        expect(plan.hotel_id).to eq hotel.id
        expect(plan.long_name).to eq '宿泊プラン【朝食付】'
        expect(plan.code).to eq 10000
        expect(plan.point_rate).to eq 10
        expect(plan.with_dinner).to eq false
        expect(plan.with_breakfast).to eq true
        expect(plan.payment_code).to eq 1
        expect(plan.description).to eq 'foo'
      end
    end
  end

  describe '#build_room' do
    context '喫煙' do
      let(:params) {
        {'roomClass' => 'sm', 'roomName' => '喫煙シングル'}
      }
      subject(:room) { api.build_room(hotel.id, params) }
      it do
        expect(room.hotel_id).to eq hotel.id
        expect(room.code).to eq 'sm'
        expect(room.name).to eq '喫煙シングル'
        expect(room.smoking).to eq true
      end
      context '同じものをいれても、SAVEはされない' do
        before { api.build_room(hotel.id, params) }
        it { expect{ api.build_room(hotel.id, params) }.to change(Room, :count).by(0) }
        it { expect(api.build_room(hotel.id, params)).to be_kind_of Room }
      end
    end

    context '禁煙' do
      let(:params) {
        {'roomClass' => 'sm', 'roomName' => '禁煙シングル'}
      }
      subject(:room) { api.build_room(hotel.id, params) }
      it do
        expect(room.hotel_id).to eq hotel.id
        expect(room.code).to eq 'sm'
        expect(room.name).to eq '禁煙シングル'
        expect(room.smoking).to eq false
      end
    end
  end

  describe '#build_charge' do
    let(:params) {
      {'stayDate' => '2014-10-10', 'total' => '2000' }
    }
    let(:room) { create(:room, hotel: hotel) }
    let(:plan) { create(:plan, hotel: hotel) }
    it { expect{ api.build_charge(hotel.id, room.id, plan.id, params)}.to change(Charge, :count).by(1) }

    context 'attributes' do
      let(:charge) { api.build_charge(hotel.id, room.id, plan.id, params) }
      it do
        expect(charge.hotel.id).to eq hotel.id
        expect(charge.plan.id).to eq plan.id
        expect(charge.room.id).to eq room.id
        expect(charge.stay_day).to eq 20141010
        expect(charge.amount).to eq 2000
      end
    end
  end

  describe '#parse_date' do
    it { expect(api.parse_date('2014-10-10')).to eq 20141010 }
    it { expect(api.parse_date('2014-10-32')).to be_nil }
  end

end
