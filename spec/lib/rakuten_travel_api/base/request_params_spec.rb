require 'spec_helper'

describe RakutenTravelApi::Base::RequestParams do
  describe '#valid_names' do
    subject(:names) { described_class.new.valid_names }
    it { expect( names ).to be_include "applicationId" }
    it { expect( names ).to be_include "affiliateId" }
    it { expect( names ).to be_include "elements" }
  end

  describe '#add_error' do
    it '複数のエラーを設定できること' do
      params = described_class.new
      params.add_error(:application_id, 'foo')
      params.add_error(:application_id, 'bar')
      expect(params.errors).to eq({'applicationId' => ['foo', 'bar']})
    end
  end

  describe '#valid?' do
    it {
      params = described_class.new
      expect(params).to_not be_valid
      expect(params.errors).to eq({'applicationId' => ['applicationId is required.']})
    }
  end
end