require 'spec_helper'

describe Api::HotelApi do
  let(:area) { create(:area, large: 'japan', middle: 'tokyo', small: 'tokyo', detail: 'D') }
  describe '#request' do
    before(:all) do
      if Settings.application_id.nil?
        pending "Rakuten applicationId is not specified."
      end
    end

    let(:api) { described_class.new(Settings.application_id) }
    subject(:response) {
      VCR.use_cassette('models/api/hotel_api/response') do
        api.request(area)
      end
    }

    it { expect(response).to be_kind_of Array }
    it { expect{response.first.save}.to change(Hotel, :count).by(1) }
  end

end
