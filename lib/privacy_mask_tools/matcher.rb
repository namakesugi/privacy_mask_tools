# coding: utf-8

# 個人情報Matcher
# 判定・マスキング・抽出の3つの機能を保持しています
module PrivacyMaskTools::Matcher

  # 携帯番号 ソフト判定用正規表現
  MOBILE_NUMBER_REGEXP = /([(（]?([0０][7-9７-９][0０])[-ー()（）・ 　]*([0-9０-９]{4})[-ー()（）・ 　]*([0-9０-９]{4})(?![0-9０-９]))/

  # 携帯番号 ハード判定用正規表現
  JARGON_MOBILE_NUMBER_REGEXP = /([(（]?([0０oO〇十]?[7-9７-９⑦-⑨七-九][0０oO〇十])[-ー()（）・ 　]*([0-9０-９oO①-⑨一-四〇壱弐参]{4})[-ー()（）・ 　]*([0-9０-９oO①-⑨一-四〇壱弐参]{4})(?![0-9０-９]))/

  # 固定電話(IP電話込) ソフト判定用正規表現
  PHONE_NUMBER_REGEXP = /([(（]?(([0０][3３4４6６])[-ー()（）・ 　]*([0-9０-９]{4})|([0０][1-9１-９]{2})[-ー()（）・ 　]*([0-9０-９]{3})|([0０][1-9１-９]{2}[0-9０-９])[-ー()（）・ 　]*([0-9０-９]{2})|([0０][1-9１-９]{2}[0-9０-９]{2})[-ー()（）・ 　]*([0-9０-９])|([0０][5５][0０])[-ー()（）・ 　]*([0-9０-９]{4}))[-ー()（）・ 　]*([0-9０-９]{4})(?![0-9０-９]))/

  # 固定電話(IP電話込) ハード判定用正規表現
  JARGON_PHONE_NUMBER_REGEXP = /([(（]?(([0０oO〇十][3３三参③4４四④6６六⑥])[-ー()（）・ 　]*([0-9０-９oO①-⑨一-四〇壱弐参]{4})|([0０oO〇十][1-9１-９一-九四①-⑨壱弐参]{2})[-ー()（）・ 　]*([0-9０-９oO①-⑨一-四〇壱弐参]{3})|([0０oO〇十][1-9１-９一-九四①-⑨壱弐参]{2}[0-9０-９oO①-⑨一-四〇壱弐参])[-ー()（）・ 　]*([0-9０-９oO①-⑨一-四〇壱弐参]{2})|([0０oO〇十][1-9１-９一-九四①-⑨壱弐参]{2}[0-9０-９oO①-⑨一-四〇壱弐参]{2})[-ー()（）・ 　]*([0-9０-９oO①-⑨一-四〇壱弐参])|([0０oO〇十][5５五⑤][0０oO〇十])[-ー()（）・ 　]*([0-9０-９oO①-⑨一-四〇壱弐参]{4}))[-ー()（）・ 　]*([0-9０-９oO①-⑨一-四〇壱弐参]{4})(?![0-9０-９]))/

  # 携帯番号が含まれているかチェックします
  #   jargonをfalseにした場合は判定条件はゆるめです
  #   そのため、漢数字や丸数字はパスしてしまいます
  #   ただし、セパレータ部分は強めの制限となっており、スペースも許容しています
  #   そのため"000     9999　　９９９９"もマッチします
  # @param [String] チェック対象の文字列
  # @param [Boolean] 隠語判定強化フラグ(漢数字・丸付き数値にもマッチ)
  # @return [Boolean]
  #   含まれている場合 true
  #   含まれていない場合 false
  def has_mobile_number?(text, jargon=false)
    reg = jargon ? JARGON_MOBILE_NUMBER_REGEXP : MOBILE_NUMBER_REGEXP
    !text.match(reg).nil?
  end

  # 携帯番号が含まれているかチェックします
  #   隠語らしきもの(漢数字・丸付き数字・〇など)も判定します
  #   そのため正常な文字列も置換する確率が高くなります
  #   現時点ではテストが不十分です
  # @param [String] チェック対象の文字列
  # @return [Boolean]
  #   含まれている場合 true
  #   含まれていない場合 false
  def has_jargon_mobile_number?(text)
    has_mobile_number?(text,true)
  end

  # 固定電話番号が含まれているかチェックします
  #
  # 基本的な仕様はhas_mobile_number?と同一です
  # @param [String] チェック対象の文字列
  # @param [Boolean]
  # @return [Boolean]
  #   含まれている場合 true
  #   含まれていない場合 false
  def has_phone_number?(text, jargon=false)
    reg = jargon ? JARGON_PHONE_NUMBER_REGEXP : PHONE_NUMBER_REGEXP
    !text.match(reg).nil?
  end

  # 固定電話番号が含まれているかチェックします
  #
  # 基本的な仕様はhas_jargon_mobile_number?と同一です
  # @param [String] チェック対象の文字列
  # @return [Boolean]
  #   含まれている場合 true
  #   含まれていない場合 false
  def has_jargon_phone_number?(text)
    has_phone_number?(text, true)
  end

  # 携帯番号らしき箇所をマスキングします
  #   wordに2文字以上を与えるとマッチした部分をその2文字で置き換えます
  #   wordが1文字だとマッチした部分それぞれの数値をその文字で置き換えます
  # @param [String] マスキング対象の文字列
  # @param [String] マッチした部分の置換文字
  # @param [Boolean] 隠語判定を強化フラグ
  # @return [String] マスキング後の文字列
  # @example
  #  mobile_number_masking("携帯番号 : 080-7900-5678"
  #  # => "携帯番号 : xxx-xxxx-xxxx"
  #  mobile_number_masking("携帯番号 : 080-7900-5678", "[Tel No]")
  #  # => "携帯番号 : [Tel No]"
  def mobile_number_masking(text, word="*", jargon=false)
    reg = jargon ? JARGON_MOBILE_NUMBER_REGEXP : MOBILE_NUMBER_REGEXP
    text.scan(reg).each do |f|
      if word.size >= 2
        text = text.sub(f[0], word)
      else
        replace_word = f[0].dup
        f.each_with_index do |g, index|
          next if index == 0
          replace_word.sub!(g, word*g.size)
        end
        text = text.sub(f[0], replace_word)
      end
    end
    text
  end

  # 固定電話らしき箇所をマスキングします
  #
  # 基本的な仕様はmobile_number_maskingと同一です
  # @see mobile_number_masking
  # @param [String] マスキング対象の文字列
  # @param [String] マッチした部分の置換文字
  # @param [Boolean] 隠語判定を強化フラグ
  # @return [String] マスキング後の文字列
  def phone_nomber_masking(text, word="*", jargon=false)
    reg = jargon ? JARGON_PHONE_NUMBER_REGEXP : PHONE_NUMBER_REGEXP
    text.scan(reg).each do |f|
      if word.size >= 2
        text = text.sub(f[0], word)
      else
        replace_word = f[0].dup
        f.each_with_index do |g, index|
          next if index <= 1 or g.nil?
          replace_word.sub!(g, word*g.size)
        end
        text = text.sub(f[0], replace_word)
      end
    end
    text
  end

end

