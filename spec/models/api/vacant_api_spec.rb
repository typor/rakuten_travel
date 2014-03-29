require 'spec_helper'

describe Api::VacantApi do
  let(:hotel) { create(:hotel, no: '509') }

  describe '#request' do
    before(:all) do
      if Settings.application_id.nil?
        pending "Rakuten applicationId is not specified."
      end
    end

    let(:api) { described_class.new(Settings.application_id) }
    let(:checkin) { 10.day.since }
    let(:vcr_name) { 'models/api/vacant_api/' + hotel.no + '_' + checkin.strftime('%Y%m%d') }
    subject(:response) {
      VCR.use_cassette(vcr_name) do
        api.request(hotel, checkin)
      end
      Area.count.tapp
    }

    it { response }
  end
end
