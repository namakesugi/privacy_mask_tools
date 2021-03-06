# coding: utf-8

require 'spec_helper'

describe PrivacyMaskTools::PhoneMatcher do
  class Obj
    include PrivacyMaskTools::PhoneMatcher
  end

  describe "Rubyにおける日本語のテスト" do

    it "'/[①-⑨]/'で①から⑨までの丸付き数値にマッチすること" do
      "①②③④⑤⑥⑦⑧⑨".scan(/[①-⑨]/).length.should eql 9
    end

    subject { "①".ord }
    it { should eql "②".ord - 1 }
    it { should eql "③".ord - 2 }
    it { should eql "④".ord - 3 }
    it { should eql "⑤".ord - 4 }
    it { should eql "⑥".ord - 5 }
    it { should eql "⑦".ord - 6 }
    it { should eql "⑧".ord - 7 }
    it { should eql "⑨".ord - 8 }
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
      it { matcher.has_jargon_mobile_number?("〇九O-①②③④-⑤⑥⑦⑧").should be_true }
    end
  end

  describe ".has_phone_number?" do
    context "携帯番号の場合" do
      it { matcher.has_phone_number?("070-0000-0000").should be_false }
      it { matcher.has_phone_number?("080-0000-0000").should be_false }
      it { matcher.has_phone_number?("090-0000-0000").should be_false }
    end
    context "マッチしない場合" do
      context "最後の数値パターンの末尾に数値が含まれている場合" do
        it { matcher.has_phone_number?("(0１9)000-00000").should be_false }
        it { matcher.has_phone_number?("019000-９９９９９").should be_false }
      end
      context "桁数が不足している場合" do
        it { matcher.has_phone_number?("011-000-000").should be_false }
      end
      context "加入者番号の桁に数値・指定された記号以外が混入している場合" do
        it { matcher.has_phone_number?("011-000<0000>").should be_false }
        it { matcher.has_phone_number?("011-000-a0000").should be_false }
      end
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
    context "IP電話の場合('([0０oO〇十][5５五⑤][0０oO〇十])[-ー()（）・ 　]*([0-9０-９oO①-⑨一-四〇壱弐参]{4})')" do
      it { matcher.has_jargon_phone_number?("o五o-①②③④-0000").should be_true }
      it { matcher.has_jargon_phone_number?("O⑤O-⑤⑥⑦⑧-0000").should be_true }
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

  describe ".pick_mobile_number" do
    context "携帯番号が1つ含まれる場合" do
      subject { matcher.pick_mobile_number("090-0000-0000です\r\nこれが私の番号です ０３・００００・９９９９") }
      its(:size) { should eql 1 }
      its([0]) { should eql "090-0000-0000" }
    end
    context "携帯番号が2つ以上含まれる場合" do
      subject { matcher.pick_mobile_number("090-0000-0000です\r\nこれが私の番号です ０９０・００００・９９９９") }
      its(:size) { should eql 2 }
      its([0]) { should eql "090-0000-0000" }
      its([1]) { should eql "０９０・００００・９９９９" }
    end
    context "jargonモードを有効にした場合" do
      subject { matcher.pick_mobile_number("0⑨0-〇①②③-0000です\r\nこれが私の番号です ０９０・００００・９９９９", true) }
      its(:size) { should eql 2 }
      its([0]) { should eql "0⑨0-〇①②③-0000" }
      its([1]) { should eql "０９０・００００・９９９９" }
    end
  end

  describe ".pick_phone_number" do
    context "電話番号が1つ含まれる場合" do
      subject { matcher.pick_phone_number("090-0000-0000です\r\nこれが私の番号です ０３・００００・９９９９") }
      its(:size) { should eql 1 }
      its([0]) { should eql "０３・００００・９９９９" }
    end
    context "電話番号が2つ以上含まれる場合" do
      subject { matcher.pick_phone_number("03-0000-0000です\r\nこれが私の番号です ０3・００００・９９９９\r\n０3０・００００・９９９９") }
      its(:size) { should eql 2 }
      its([0]) { should eql "03-0000-0000" }
      its([1]) { should eql "０3・００００・９９９９" }
    end
    context "jargonモードを有効にした場合" do
      subject { matcher.pick_phone_number("〇参-0000-0000です\r\nこれが私の番号です ０3・００００・９９９９\r\n０3０・００００・９９９９", true) }
      its(:size) { should eql 2 }
      its([0]) { should eql "〇参-0000-0000" }
      its([1]) { should eql "０3・００００・９９９９" }
    end
  end
end

