require 'spec_helper'

describe RakutenTravelApi::SimpleHotelSearch::Client do
  before(:all) do
    if Settings.application_id.nil?
      pending "Rakuten applicationId is not specified."
    end
  end

  let(:client) { RakutenTravelApi::SimpleHotelSearch::Client.new(Settings.application_id, Settings.affiliate_id) }

  context 'simple case' do
    let(:response) {
      VCR.use_cassette('simple_hotel_search/simple_case') do
        client.request do |o|
          o.add_params(large_class_code: 'japan', middle_class_code: 'tokyo', small_class_code: 'tokyo', detail_class_code: 'D')
        end
      end
    }

    context 'response' do
      it 'is a Response' do
        expect(response).to be_kind_of(::RakutenTravelApi::SimpleHotelSearch::Response)
      end

      it 'is success' do
        expect(response).to be_success
      end

      it '#hotels' do
        expect(response.hotels.size).to be > 0
      end

      it '#next?' do
        expect(response).to be_next
      end

      it '#current_page' do
        expect(response.current_page).to eq 1
      end

      it '#page_count' do
        expect(response.page_count).to be > 1
      end

      it '#prev?' do
        expect(response).to_not be_prev
      end
    end

    context 'next' do
      let(:next_page) {
        response
        VCR.use_cassette('simple_hotel_search/next') do
          client.next
        end
      }
      it { expect(next_page.current_page).to eq 2 }
      it { expect(next_page).to be_success }
    end
  end
end