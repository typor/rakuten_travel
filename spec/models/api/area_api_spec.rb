require 'spec_helper'

describe Api::AreaApi do

  let(:api) { Api::AreaApi.new(Settings.application_id) }

  describe '#request' do
    before(:all) do
      if Settings.application_id.nil?
        pending "Rakuten applicationId is not specified."
      end
    end

    subject(:response) {
      VCR.use_cassette('models/api/area_api/response') do
        api.request
      end
    }

    it { expect(response).to be_kind_of Array }
    it { expect{response.first.save}.to change(Area, :count).by(1) }
  end

  describe '#build_area' do
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
    context 'not find' do
      subject(:area) { api.build_area(example_params) }
      it { expect(area).to be_kind_of Area }
      it { expect(area).to be_new_record }
      it { expect(area.long_name).to eq '北海道/札幌市内/JR札幌駅周辺・新札幌駅' }
      it { expect(area.large).to eq 'japan' }
      it { expect(area.middle).to eq 'hokkaido' }
      it { expect(area.small).to eq 'sapporo' }
      it { expect(area.detail).to eq 'A' }
    end

    context 'find' do
      before { api.build_area(example_params).save }
      subject(:area) { api.build_area(example_params) }
      it { expect(area).to_not be_new_record }
    end
  end
end
