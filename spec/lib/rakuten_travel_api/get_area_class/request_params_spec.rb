require 'spec_helper'

describe RakutenTravelApi::GetAreaClass::RequestParams do
  describe '#valid_names' do
    subject(:names) { described_class.new.valid_names }
    it { expect( names ).to be_include "applicationId" }
    it { expect( names ).to be_include "affiliateId" }
    it { expect( names ).to be_include "elements" }
  end
end