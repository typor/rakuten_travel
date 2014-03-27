require 'spec_helper'

describe RakutenTravelApi::Base::RequestParams do
  let(:params) { described_class.new }

  describe '#normalize' do
    it { expect(params.normalize('application_id')).to eq 'applicationId' }
    it { expect(params.normalize(:application_id)).to eq 'applicationId' }
    it { expect(params.normalize('applicationId')).to eq 'applicationId' }
    it { expect(params.normalize(:applicationId)).to eq 'applicationId' }
  end

  describe '#valid_names' do
    subject(:names) { params.valid_names }
    it { expect( names ).to be_include "applicationId" }
    it { expect( names ).to be_include "affiliateId" }
    it { expect( names ).to be_include "elements" }
  end

  describe '#[], #[]=' do
    it '値設定ができること' do
      params['applicationId'] = '123'
      expect(params['applicationId']).to eq '123'
    end

    it 'normalizeされること' do
      params['application_id'] = '123'
      expect(params['applicationId']).to eq '123'
      expect(params['application_id']).to eq '123'
    end
  end

  describe '#to_hash' do
    it 'nilは削除されること' do
      params['applicationId'] = '123'
      params['affiliateId'] = nil
      expect(params.to_hash).to eq({'applicationId' => '123'})
    end
  end

  describe '#add_param' do
    it '要素の追加ができること' do
      params.add_param 'applicationId', '123'
      expect(params['applicationId']).to eq '123'
    end

    it 'normalizeされること' do
      params.add_param :application_id, '123'
      expect(params['applicationId']).to eq '123'
    end

  end

  describe '#add_params' do
    it '複数の要素を追加できること' do
      params.add_params application_id: '123', affiliate_id: '234'
      expect(params.to_hash).to eq({'applicationId' => '123', 'affiliateId' => '234'})
    end
  end

end