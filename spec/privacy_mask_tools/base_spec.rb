# coding: utf-8
require 'spec_helper'

describe PrivacyMaskTools::Base do
  describe "#has_mobile_number?" do
    it { PrivacyMaskTools::Base.has_mobile_number?("私の携帯電話番号は 090-1234-5678 です").should be_true }
  end
  describe "#has_jargon_mobile_number?" do
    it { PrivacyMaskTools::Base.has_jargon_mobile_number?("私の携帯電話番号は 〇九O-①②③④-⑤⑥⑦⑧ です").should be_true }
  end
  describe "#mobile_number_masking" do
    it { PrivacyMaskTools::Base.mobile_number_masking("私の携帯電話番号は 090-1234-5678 です").should eql "私の携帯電話番号は ***-****-**** です" }
  end

  describe "#has_phone_number?" do
    it { PrivacyMaskTools::Base.has_phone_number?("私の電話番号は　03-0000-0000 です").should be_true }
  end

  describe "#has_jargon_phone_number?" do
    it { PrivacyMaskTools::Base.has_jargon_phone_number?("私の電話番号は　〇三ー壱弐参四ー五六七八　です").should be_true }
  end

  describe "#phone_nomber_masking" do
    it { PrivacyMaskTools::Base.phone_nomber_masking("私の電話番号は　03-0000-0000　です\r\n私のFAX番号は　０３ー００００ー００００　です").should
      eql "私の電話番号は　xx-xxxx-xxxx　です\r\n私のFAX番号は　xxーxxxxーxxxx　です" }
  end

  describe "#has_rfc_email?" do
    it { PrivacyMaskTools::Base.has_rfc_email?("hogehoge@namaeksugi.net").should be_true }
  end

  describe "#has_rfc_email?" do
    it { PrivacyMaskTools::Base.has_rfc_email?("hogehoge@namaeksugi.net").should be_true }
  end

  describe "#pick_rfc_email" do
    subject { PrivacyMaskTools::Base.pick_rfc_email("お問い合わせは info@namakesugi.net まで") }
    its([0]) { should eql "info@namakesugi.net" }
  end

  describe "#rfc_email_masking" do
    subject { PrivacyMaskTools::Base.rfc_email_masking("お問い合わせは info@namakesugi.net まで") }
    it { should eql "お問い合わせは *** まで" }
  end
end

