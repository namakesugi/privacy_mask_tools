# coding: utf-8

require 'spec_helper'

describe PrivacyMaskTools::Matcher do
  class Obj
    include PrivacyMaskTools::Matcher
  end

  describe "Rubyにおける日本語のテスト" do
    it "'/[一-四]/'で一から十までの漢数字にマッチすること" do
      "一二三四五六七八九十".scan(/[一-四]/).length.should eql 10
    end

    it "'/[①-⑨]/'で①から⑨までの丸付き数値にマッチすること" do
      "①②③④⑤⑥⑦⑧⑨".scan(/[①-⑨]/).length.should eql 9
    end
  end

  let!(:matcher) { Obj.new }

  describe ".has_mobile_number?" do
    describe "携帯番号が含まれている" do
      it { matcher.has_mobile_number?("08076000000").should be_true }
      it { matcher.has_mobile_number?("080-7600-0000").should be_true }
      it { matcher.has_mobile_number?("a080-7600-0000a").should be_true }
      context "連続する数値中に含まれる場合" do
        it { matcher.has_mobile_number?("008076000000").should be_true }
      end
      context "スペースが含まれる場合" do
        it { matcher.has_mobile_number?("080  7600 0000").should be_true }
        it { matcher.has_mobile_number?("080　　(7600)　0000").should be_true }
      end
      context "全角数字が含まれている場合" do
        it { matcher.has_mobile_number?("０８０７６３４５６７８").should be_true }
        it { matcher.has_mobile_number?("0８0(７９34）567８").should be_true }
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

  describe ".has_jargon_mobile_number?" do
    context "漢数字・丸付き数字・o等が含まれている場合" do
      it { matcher.has_jargon_mobile_number?("0⑧0-1②参四-oO十〇").should be_true }
    end
  end

  describe ".has_phone_number?" do
    context "携帯番号の場合" do
      it { matcher.has_phone_number?("070-0000-0000").should be_false }
      it { matcher.has_phone_number?("080-0000-0000").should be_false }
      it { matcher.has_phone_number?("090-0000-0000").should be_false }
    end
    context "([0０][3３4４6６])[-ー()（）・ 　]*([0-9０-９]{4})の場合" do
      it { matcher.has_phone_number?("03-0000-1234").should be_true }
      it { matcher.has_phone_number?("０４-００００ー１２３４").should be_true }
      it { matcher.has_phone_number?("0600000000").should be_true }
    end
    context "([0０][1-9１-９]{2})[-ー()（）・ 　]*([0-9０-９]{4})の場合" do
      it { matcher.has_phone_number?("011-000ー0000").should be_true }
      it { matcher.has_phone_number?("０９９-９９９ー００００").should be_true }
      it { matcher.has_phone_number?("0１90000000").should be_true }
      it { matcher.has_phone_number?("(0１9)000-00000").should be_false }
    end
    context "([0０][1-9１-９]{2}[0-9０-９])[-ー()（）・ 　]*([0-9０-９]{2}の場合" do
      it { matcher.has_phone_number?("0110-00-0000").should be_true }
      it { matcher.has_phone_number?("０９９０・００・００００").should be_true }
      it { matcher.has_phone_number?("０１10000000").should be_true }
    end
    context "([0０][1-9１-９]{2}[0-9０-９]{2})[-ー()（）・ 　]*([0-9０-９])の場合" do
      it { matcher.has_phone_number?("01100-0-0000").should be_true }
      it { matcher.has_phone_number?("０９９９９ー９ー９９９９").should be_true }
      it { matcher.has_phone_number?("01９0９00000").should be_true }
    end
    context "IP電話の場合('([0０][5５][0０])[-ー()（）・ 　]*(0-9０-９)')の場合" do
      it { matcher.has_phone_number?("050-0000-0000").should be_true }
      it { matcher.has_phone_number?("０５０００００００００").should be_true }
      it { matcher.has_phone_number?("０5０（０00０)9９9９").should be_true }
    end
  end

  describe ".has_jargon_phone_number?" do
    context "([0０oO〇十][3３三参③4４四④6６六⑥])[-ー()（）・ 　]*([0-9０-９oO①-⑨一-四〇壱弐参]{4})の場合" do
      it { matcher.has_jargon_phone_number?("o三-①②③④-①②③④").should be_true }
      it { matcher.has_jargon_phone_number?("O参-⑤⑥⑦⑧-⑤⑥⑦⑧").should be_true }
      it { matcher.has_jargon_phone_number?("〇③-⑨一二三-⑨一二三").should be_true }
      it { matcher.has_jargon_phone_number?("〇四-四五六七-四五六七").should be_true }
      it { matcher.has_jargon_phone_number?("〇④-八九〇壱-八九〇壱").should be_true }
      it { matcher.has_jargon_phone_number?("〇六-弐参oO-弐参oO").should be_true }
      it { matcher.has_jargon_phone_number?("〇⑥１１１１１１１１").should be_true }
    end
    # TODO more test
  end

  describe ".mobile_number_masking" do
    it { matcher.mobile_number_masking("080-7900-0000").should eql "***-****-****" }
    it { matcher.mobile_number_masking("０８０７９００００００","x").should eql "xxxxxxxxxxx" }
    context "複数マッチする箇所がある場合" do
      it { matcher.mobile_number_masking("abc:080-7900-0000\n090 080-7800-0000").should eql "abc:***-****-****\n090 ***-****-****" }
    end

    context "subに2文字以上与えた場合" do
      it { matcher.mobile_number_masking("電話番号は 080（７６００）0000.1です", "No").should eql "電話番号は No.1です" }
    end
  end

  describe ".phone_nomber_masking" do
    it { matcher.phone_nomber_masking("03-0000-1234").should eql "**-****-****" }
    it { matcher.phone_nomber_masking("これが私の番号です ０３・００００・９９９９", "○").should eql "これが私の番号です ○○・○○○○・○○○○" }

    context "subに2文字以上与えた場合" do
      it { matcher.phone_nomber_masking("これが私の番号です\r\n ０３・００００・９９９９", "No").should eql "これが私の番号です\r\n No" }
    end
  end
end

