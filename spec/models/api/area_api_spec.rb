require 'spec_helper'

describe Api::AreaApi do

  describe '#to_area' do
    let(:example_params) {
      {
        "largeClassCode"=>"japan",
        "largeClassName"=>"日本",
        "middleClassCode"=>"hokkaido",
        "middleClassName"=>"北海道",
        "smallClassCode"=>"sapporo",
        "smallClassName"=>"札幌市内",
        "detailClassCode"=>"A",
        "detailClassName"=>"JR札幌駅周辺・新札幌駅"
      }
    }
    subject(:area) { described_class.new.to_area(example_params) }
    it { expect(area).to be_kind_of Area }
    it { expect(area.name).to eq '北海道-札幌市内-JR札幌駅周辺・新札幌駅' }
    it { expect(area.large).to eq 'japan' }
    it { expect(area.middle).to eq 'hokkaido' }
    it { expect(area.small).to eq 'sapporo' }
    it { expect(area.detail).to eq 'A' }
  end
end
