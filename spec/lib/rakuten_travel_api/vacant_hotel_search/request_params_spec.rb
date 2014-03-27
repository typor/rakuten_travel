require 'spec_helper'

describe RakutenTravelApi::VacantHotelSearch::RequestParams do
  describe '#valid_names' do
    subject(:names) { described_class.new.valid_names }
    it { expect( names ).to be_include "applicationId" }
    it { expect( names ).to be_include "affiliateId" }
    it { expect( names ).to be_include "largeClassCode" }
    it { expect( names ).to be_include "middleClassCode" }
    it { expect( names ).to be_include "smallClassCode" }
    it { expect( names ).to be_include "detailClassCode" }
    it { expect( names ).to be_include "hotelNo" }
    it { expect( names ).to be_include "checkinDate" }
    it { expect( names ).to be_include "checkoutDate" }
    it { expect( names ).to be_include "maxCharge" }
    it { expect( names ).to be_include "minCharge" }
    it { expect( names ).to be_include "squeezeCondition" }
    it { expect( names ).to be_include "carrier" }
    it { expect( names ).to be_include "searchPattern" }
    it { expect( names ).to be_include "page" }
  end
end