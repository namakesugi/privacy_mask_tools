# coding: utf-8
require 'spec_helper'

describe PrivacyMaskTools::Base do
  describe "#has_mobile_number?" do
    it { PrivacyMaskTools::Base.has_mobile_number?("私の携帯電話番号は 090-1234-5678 です").should be_true }
  end
  describe "#has_jargon_mobile_number?" do
    it { PrivacyMaskTools::Base.has_jargon_mobile_number?("私の携帯電話番号は 090-1234-5678 です").should be_true }
  end
  describe "#mobile_number_masking" do
    it { PrivacyMaskTools::Base.mobile_number_masking("私の携帯電話番号は 090-1234-5678 です").should eql "私の携帯電話番号は ***-****-**** です" }
  end
end

