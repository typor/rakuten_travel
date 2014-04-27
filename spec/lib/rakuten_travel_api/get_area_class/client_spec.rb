require 'spec_helper'

describe RakutenTravelApi::GetAreaClass::Client do
  before(:all) do
    if RakutenApiSettings.application_id.nil?
      skip "Rakuten applicationId is not specified."
    end
  end

  let(:client) { RakutenTravelApi::GetAreaClass::Client.new(RakutenApiSettings.application_id, RakutenApiSettings.affiliate_id) }

  context 'simple case' do
    let(:response) {
      VCR.use_cassette('get_area_class/simple_case') do
        client.request
      end
    }

    context 'response' do
      it 'is a Response' do
        expect(response).to be_kind_of(::RakutenTravelApi::GetAreaClass::Response)
      end

      it 'is success' do
        expect(response).to be_success
      end

      it { expect(response.areas).to be_kind_of Array }
      it { expect(response.areas[0]).to be_kind_of Hash }
    end
  end

end