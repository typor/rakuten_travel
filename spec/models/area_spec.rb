require 'spec_helper'

describe Area do
  describe "#to_api_params" do
    it "全フィールドがnilの場合" do
      expect(Area.new.to_api_params).to eq({})
    end

    it "フィールドが設定されている場合" do
      expect(
        Area.new(name: 'foo', large: 'bar', middle: 'baz', small: 'qux', detail: 'quux').to_api_params
      ).to eq({
        largeClassCode: 'bar',
        middleClassCode: 'baz',
        smallClassCode: 'qux',
        detailClassCode: 'quux'
      })
    end
  end
end
