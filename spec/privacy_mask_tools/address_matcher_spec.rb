# coding: utf-8

require 'spec_helper'

describe PrivacyMaskTools::AddressMatcher do
  class Obj
    include PrivacyMaskTools::AddressMatcher
  end

  let!(:matcher) { Obj.new }
  let!(:lists) { [
   "東京都港区赤坂３３５",
   "東京都千代田区大手町２６２",
   "東京都千代田区大手町１１２",
   "横浜市都筑区仲町台２７１",
   "長野市南堀１３８１",
   "新潟県南魚沼市余川８９",
   "北海道上川郡東神楽町１４北１",
   "東京都中央区日本橋本石町３１２ ダヴィンチ新常磐橋",
   "東京都千代田区丸の内２４１ 丸の内ビルディング",
   "東京都墨田区両国２１０１４ 両国シティコア",
   "京都市山科区椥辻中在家町８１ ＳＥＥＤ山科中央ビル",
   "東京都港区虎ノ門１１６１６ 虎ノ門１丁目ＭＧビルディング",
   "名古屋市中区丸の内２１３３",
   "川崎市幸区堀川町５８０ ソリッドスクエア西館",
   "福島県いわき市常磐湯本町辰ノ口１",
   "東京都新宿区西早稲田２２０９ 西早稲田オーシャンビル",
   "東京都新宿区西新宿１２５１ 新宿センタービル",
   "東京都新宿区信濃町３４ ＪＲ信濃町ビル"
    ]
  }
  describe ".has_address?" do
    it "アドレスが含まれる" do
      lists.each { |f| matcher.has_address?(f.tapp).should be_true }
    end

    context "市区村が含まれない場合" do
      it { matcher.has_address?("新宿信濃町３４ ＪＲ信濃町ビル").should be_false }
      it { matcher.has_address?("東京都新宿信濃町３４ ＪＲ信濃町ビル").should be_false }
      it { matcher.has_address?("福島県いわき常磐湯本町辰ノ口１").should be_false }
    end

    context "市区村名が6文字の場合" do
      it { matcher.has_address?("いちき串木野市３４ ＪＲ信濃町ビル").should be_true }
      it { matcher.has_address?("東京都かすみがうら村３４ ＪＲ信濃町ビル").should be_true }
      it { matcher.has_address?("東京都　つくばみらい区３４ ＪＲ信濃町ビル").should be_true }
    end

    context "市区村名が7文字の場合" do
      it { matcher.has_address?("ほげほげほげほ村３４ ＪＲ信濃町ビル").should be_false }
      it { matcher.has_address?("東京都ほげほげほげほ市３４ ＪＲ信濃町ビル").should be_false }
      it { matcher.has_address?("東京都　ほげほげほげほ区３４ ＪＲ信濃町ビル").should be_false }
    end

    context "市区村名にカタカナが含まれる場合" do
      it { matcher.has_address?("横浜市保土ヶ谷区３４ ＪＲ信濃町ビル").should be_true }
    end
  end
end

