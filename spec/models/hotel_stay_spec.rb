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
      it { expect(described_class.new.search).to eq({}) }
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

  describe '#build_plan_url' do
    let(:obj) { HotelStay.new(hotel: hotel) }
    subject(:url) { obj.build_plan_url('20141001', 1) }
    after { RakutenApiSettings.init }

    context 'has affiliate_id' do
      before {
        RakutenApiSettings.init
        allow(Settings).to receive(:rakuten_api_keys).and_return([{'affiliate_id' => 'b', 'application_id' => 'a'}])
      }
      specify { expect(url).to eq(HotelStay::AFFILIATE_URL_BASE + 'b/?pc=' + CGI.escape(obj.plan_url('20141001', 1))) }
    end

    context 'not have affiliate_id' do
      before {
        RakutenApiSettings.init
        allow(Settings).to receive(:rakuten_api_keys).and_raise Settingslogic::MissingSetting
      }
      specify { expect(url).to eq obj.plan_url('20141001', 1) }
    end
  end

  describe '#plan_url_params' do
    let(:start) { 1.days.ago }
    let(:finish) { 0.days.ago }
    subject(:params) { HotelStay.new.plan_url_params(start, finish) }
    specify do
      expect(params).to eq(
        {
          f_nen1: start.year,
          f_tuki1: start.month,
          f_hi1: start.day,
          f_nen2: finish.year,
          f_tuki2: finish.month,
          f_hi2: finish.day,
          f_heya_su: 1,
          f_otona_su: 1
        }
      )
    end
  end

  describe '#gender' do
    let(:stay) { HotelStay.new(hotel: hotel) }
    specify { expect(stay.gender).to eq 0 }
  end

  describe '#room_ids' do
    let(:search) { HotelStay.new(hotel: hotel) }
    let!(:room1) { create(:room, hotel: hotel, smoking: true, ladies: false, enabled: true) }
    let!(:room2) { create(:room, hotel: hotel, smoking: true, ladies: true, enabled: true) }
    let!(:room3) { create(:room, hotel: hotel, smoking: false, ladies: false, enabled: true) }
    let!(:room4) { create(:room, hotel: hotel, smoking: false, ladies: true, enabled: true) }
    let!(:room5) { create(:room, hotel: hotel, smoking: false, ladies: true, enabled: false) }
    subject(:ids) { search.room_ids }

    context 'default' do
      specify { expect(ids).to eq [room1.id, room2.id, room3.id, room4.id] }
    end

    context 'filter smoking' do
      before {
        search.smoking = 1
      }
      specify { expect(ids).to eq [room1.id, room2.id] }
    end

    context 'filter nonsmoking' do
      before {
        search.smoking = 2
      }
      specify { expect(ids).to eq [room3.id, room4.id] }
    end

    context 'filter notladis' do
      before {
        search.gender = 1
        specify { expect(ids).to eq [room1.id, room3.id] }
      }
    end

    context 'filter notladis' do
      before {
        search.gender = 2
      }
      specify { expect(ids).to eq [room2.id, room4.id] }
    end
  end
end