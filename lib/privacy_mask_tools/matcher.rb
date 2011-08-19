# coding: utf-8

module PrivacyMaskTools::Matcher
  # 携帯番号ソフト判定用正規表現
  MOBILE_NUMBER_REGEXP = /(([0０][7-9７-９][0０])[-ー)(（） 　]*([0-9０-９]{4})[-ー)(（） 　]*([0-9０-９]{4})(?![0-9０-９]))/

  # 携帯番号ハード判定用正規表現(丸付数字等も含める)
  JARGON_MOBILE_NUMBER_REGEXP = /(([0０oO〇十]?[7-9７-９⑦⑧⑨][0０十〇])[-ー)(（） 　]*([0-9０-９oO①②③④⑤⑥⑦⑧⑨一二三四五六七八九十〇壱弐参]{4})[-ー)(（） 　]*([0-9０-９oO①②③④⑤⑥⑦⑧⑨一二三四五六七八九十〇壱弐参]{4})(?![0-9０-９]))/

  # 携帯番号が含まれているかチェックします
  #   隠語判定はソフトで、半角全角の携帯番号らしきものはtrueを返します
  # @param [String] チェック対象の文字列
  # @param [Boolean] 隠語判定強化フラグ(漢数字・丸付き数値にもマッチ)
  # @return [Boolean]
  #  含まれている場合 true
  #  含まれていない場合 false
  def has_mobile_number?(text, jargon=false)
    reg = jargon ? JARGON_MOBILE_NUMBER_REGEXP : MOBILE_NUMBER_REGEXP
    !text.match(reg).nil?
  end

  # 携帯番号が含まれているかチェックします
  #   隠語らしきものも判定します
  #   そのため正常な文字列も置換する確率が高くなります
  #   現時点ではテストが不十分です
  # @param [String] チェック対象の文字列
  # @return [Boolean]
  #  含まれている場合 true
  #  含まれていない場合 false
  def has_jargon_mobile_number?(text)
    has_mobile_number?(text,true)
  end

  # 携帯番号らしき箇所をマスキングします
  # @param [String] マスキング対象の文字列
  # @param [String] マッチした部分の置換文字
  # @param [Boolean] 隠語判定を強化フラグ
  # @return [String] マスキング後の文字列
  # @example
  #  mobile_number_masking("携帯番号 : 090-1234-5678")
  #  # => "携帯番号 : xxx-xxxx-xxxx"
  def mobile_number_masking(text, sub="*", jargon=false)
    reg = jargon ? JARGON_MOBILE_NUMBER_REGEXP : MOBILE_NUMBER_REGEXP
    text.scan(reg).each do |f|
      replace_word = f[0].dup
      f.each_with_index do |g, index|
        next if index == 0
        replace_word.sub!(g, sub*g.size)
      end
      text = text.sub(f[0], replace_word)
    end
    text
  end
end

