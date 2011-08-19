# coding: utf-8

require 'spec_helper'

describe PrivacyMaskTools::Matcher do
  class Obj
    include PrivacyMaskTools::Matcher
  end

  let!(:matcher) { Obj.new }

  describe ".has_mobile_number?" do
    describe "携帯番号が含まれている" do
      it { matcher.has_mobile_number?("09012345678").should be_true }
      it { matcher.has_mobile_number?("090-1234-5678").should be_true }
      it { matcher.has_mobile_number?("a090-1234-5678a").should be_true }
      context "連続する数値中に含まれる場合" do
        it { matcher.has_mobile_number?("009012345678").should be_true }
      end
      context "スペースが含まれる場合" do
        it { matcher.has_mobile_number?("090  1234 5678").should be_true }
        it { matcher.has_mobile_number?("090　(1234)　5678").should be_true }
      end
      context "全角数字が含まれている場合" do
        it { matcher.has_mobile_number?("０９０１２３４５６７８").should be_true }
        it { matcher.has_mobile_number?("0９0(１234）567８").should be_true }
      end
    end

    describe "携帯番号が含まれていない" do
      it { matcher.has_mobile_number?("あいうえおaiueo").should be_false }
      it { matcher.has_mobile_number?("19012345678").should be_false }
      it { matcher.has_mobile_number?("09112345678").should be_false }

      context "携帯番号+数値の場合" do
        subject { matcher.has_mobile_number?("090123456781") }
        it { should be_false }
      end
    end
  end

  describe ".has_jargon_mobile_number" do
    it { matcher.has_jargon_mobile_number?("0⑨0-1②参四-oO十〇").should be_true }
  end

  describe ".mobile_number_masking" do
    it { matcher.mobile_number_masking("090-1234-5678").should eql "***-****-****" }
    it { matcher.mobile_number_masking("０９０１２３４５６７８","x").should eql "xxxxxxxxxxx" }
    context "複数マッチする箇所がある場合" do
      it { matcher.mobile_number_masking("abc:090-1234-5678\n090 090-1111-2222").should eql "abc:***-****-****\n090 ***-****-****" }
    end
  end
end

