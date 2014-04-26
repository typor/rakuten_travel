require 'spec_helper'

describe ApplicationHelper do
  describe 'google_analytics_tag' do
    subject(:tag) { helper.google_analytics_tag }
    context 'Settings.google_analytics specified' do
      before {
        allow(Settings).to receive(:google_analytics).and_return('UA-XXXXXX')
      }
      specify { expect(tag).to be_include "ga('create', 'UA-XXXXXX', 'auto')" }
    end

    context 'Settings.google_analytics not specified' do
      before {
        allow(Settings).to receive(:google_analytics).and_raise Settingslogic::MissingSetting
      }
      specify { expect(tag).to be_include '' }
    end
  end
end