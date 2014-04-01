require 'spec_helper'

describe Hotel do
  describe '#save' do
    it '保存できること' do
      expect {
        described_class.create(area: create(:area), no: '123', long_name: 'foo', postal_code: '123-4567', address1: 'foo', address2: 'bar', telephone_no: '03-1111-2222', access: 'baz', image_url: 'http://foo.com/', url: 'http://bar.com/')
      }.to change{Hotel.count}.by(1)
    end
  end

  describe '#safe_keys' do
    subject(:safe_keys) { described_class.new.safe_keys }
    it { expect(safe_keys).to_not be_include('created_at') }
    it { expect(safe_keys).to be_include('area_id') }
  end
end
