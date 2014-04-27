require 'spec_helper'

describe RakutenApiSettings do
  let(:keys) {
    [
      {'boost' => 2, 'application_id' => 'a', 'affiliate_id' => 1},
      {'boost' => 3, 'application_id' => 'b', 'affiliate_id' => 1},
      {'boost' => 1, 'affiliate_id' => 1},
    ]
  }

  before {
    described_class.init
  }

  describe '#build_keys' do
    specify do
      expect(described_class.build_keys(keys)).to eq(
        [
          {application_id: 'a', affiliate_id: 1},
          {application_id: 'a', affiliate_id: 1},
          {application_id: 'b', affiliate_id: 1},
          {application_id: 'b', affiliate_id: 1},
          {application_id: 'b', affiliate_id: 1}
        ]
      )
    end
  end

  describe '#application_id, #affiliate_id' do
    context 'has keys' do
      before {
        allow(Settings).to receive(:rakuten_api_keys).and_return([{'application_id' => 'a', 'affiliate_id' => 'b'}])
      }
      specify { expect(described_class.application_id).to eq 'a' }
      specify { expect(described_class.affiliate_id).to eq 'b' }
    end

    context 'not have keys' do
      before {
        allow(Settings).to receive(:rakuten_api_keys).and_raise Settingslogic::MissingSetting
      }
      specify { expect(described_class.application_id).to be_nil }
      specify { expect(described_class.affiliate_id).to be_nil }
    end
  end
end