require 'spec_helper'

describe Area do
  let(:example_model) { described_class.new(long_name: 'foo', large: 'bar', middle: 'baz', small: 'qux', detail: 'quux') }
  describe '#validate' do
    let(:attributes) { {long_name: 'foo', large: 'a', middle: 'b', small: 'c', detail: 'd'} }
    before {
      described_class.new(attributes).save
    }
    it {
      model = described_class.new(attributes)
      expect { model.save }.to change(Area, :count).by(0)
      expect(model.errors['middle']).to_not be_nil
    }
  end

  describe '#save' do
    it '保存できること' do
      expect { example_model.save }.to change(Area, :count).by(1)
    end
  end

  describe "#to_api_params" do
    it "全フィールドがnilの場合" do
      expect(Area.new.to_api_params).to eq({})
    end

    it "フィールドが設定されている場合" do
      expect(example_model.to_api_params).to eq({
        largeClassCode: 'bar',
        middleClassCode: 'baz',
        smallClassCode: 'qux',
        detailClassCode: 'quux'
      })
    end
  end
end
