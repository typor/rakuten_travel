require 'spec_helper'

describe RakutenTravelApi::SimpleHotelSearch::RequestParams do
  describe '#valid_names' do
    subject(:names) { described_class.new.valid_names }
    it { expect( names ).to be_include "largeClassCode" }
    it { expect( names ).to be_include "middleClassCode" }
    it { expect( names ).to be_include "smallClassCode" }
    it { expect( names ).to be_include "detailClassCode" }
    it { expect( names ).to be_include "applicationId" }
    it { expect( names ).to be_include "affiliateId" }
  end
end