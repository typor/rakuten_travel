require 'spec_helper'

describe RakutenTravelApi::HotelDetailSearch::RequestParams do
  describe '#valid_names' do
    subject(:names) { described_class.new.valid_names }
    it { expect( names ).to be_include "applicationId" }
    it { expect( names ).to be_include "affiliateId" }
    it { expect( names ).to be_include "hotelNo" }
    it { expect( names ).to be_include "carrier" }
    it { expect( names ).to be_include "datumType" }
    it { expect( names ).to be_include "hotelThumbnailSize" }
    it { expect( names ).to be_include "responseType" }
  end
end