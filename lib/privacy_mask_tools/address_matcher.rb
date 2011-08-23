# coding: utf-8

# 住所判定用モジュール
module PrivacyMaskTools::AddressMatcher

  def has_address?(text)
    !text.tapp.match(make_address_regexp).tapp.nil?
  end

  # 住所の正規表現を生成します
  def make_address_regexp
    Regexp.new(prefecture_regexp + '?(' + city_regexp + '|' + gun_regexp + ')')
  end

  # 都道府県の正規表現(全県のリストだが)
  # @return [String]
  def prefecture_regexp
    "(北海道|青森県|岩手県|宮城県|秋田県|山形県|福島県|茨城県|栃木県|群馬県|埼玉県|千葉県|東京都|神奈川県|新潟県|富山県|石川県|福井県|山梨県|長野県|岐阜県|静岡県|愛知県|三重県|滋賀県|京都府|大阪府|兵庫県|奈良県|和歌山県|鳥取県|島根県|岡山県|広島県|山口県|徳島県|香川県|愛媛県|高知県|福岡県|佐賀県|長崎県|熊本県|大分県|宮崎県|鹿児島県|沖縄県)"
  end

  # 市区町村の正規表現です
  #
  # 群の場合は、その配下に町または村が来る(100%くるかは不明)ので抽出ができるようにグルーピング
  # TODO 市区村の最大値はGoogleによると6文字らしいのでそれに対応(平仮名で入力された場合は今回は除外
  # @return [String]
  def city_regexp
    "([#{jp_char_group}]+[市区村])"
  end

  def gun_regexp
    "([#{jp_char_group}]+郡[#{jp_char_group}]+[町村])"
  end

  # 市区町村以下の番地などの正規表現です
  #
  # あっているかどうかさっぱりわからない
  # これどうやって書くんだろ
  # @return [String]
  def other_regexp
    "(.{1,20}[-0-9０-９一-四F番地号条線西東丁目階の]+[#{jp_char_group}a-zA-ZＡ-Ｚ]?(?! 　))"
  end

  # 日本語の漢字・ひらがな文字集合
  # @return [String]
  def jp_char_group
    "一-龠" + "あ-んが-ぼぁ-ょゎっー" + "ア-ンガ-ボァ-ョヮッー"
  end
end

