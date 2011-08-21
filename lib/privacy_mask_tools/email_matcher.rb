# coding: utf-8

# Email判定用モジュール
module PrivacyMaskTools::EmailMatcher

  # RFC5322形式に近いメールアドレスが存在するかチェックします
  # @param [String] 探索対象文字列
  # @return [Boolean]
  def has_rfc_email?(text)
    !text.match(make_rfc_regexp).nil?
  end

  # RFC5322形式に近いメールアドレスを抽出します
  # @param [String] 探索対象文字列
  # @return [Array]
  def pick_rfc_email(text)
    [].tap { |o|
      text.scan(make_rfc_regexp) { |f| o << f[0] }
    }
  end

  # RFC5322形式に近いメールアドレスをマスキングします
  # @param [String] 探索対象文字列
  # @param [String] 置換文字列
  # @return [String] 置換後の文字列
  def rfc_email_masking(text, words="***")
    text.dup.tap {|o| text.scan(make_rfc_regexp) { |f| o.sub!(f[0], words) } }
  end

  # ----- メールアドレス正規表現メソッド -----

  # RFC5322 に対応した正規表現を生成します
  #   概ね対応しているレベルであり、完全に対応しているわけではありません
  #
  # validates_email_format_ofを参考にしています
  # @see https://github.com/alexdunae/validates_email_format_of
  # TODO chache
  def make_rfc_regexp
    Regexp.new('(('+ unquoted_regexp + '|' + quoted_regexp + '+)@(' + domain_regexp + '))')
  end

  # メールアドレスのローカル部で使用可能な特殊記号
  # @return [String] エスケープ処理された特殊記号
  def special_char
    Regexp.escape('!#$%&\'*-/=?+-^_`{|}~')
  end

  # メールアドレスのローカル部のダブルクウォーテーションで囲まれた部分で使用可能な特殊記号
  # @return [String] エスケープ処理された特殊記号
  def quoted_special_char
    Regexp.escape('()<>[]:;@, ')
  end

  # メールアドレスのローカル部の正規表現文字列
  #   このままだと文字列ですので、Regexp.new等で正規表現に変換する必要があります
  # @return [String] 正規表現文字列
  def unquoted_regexp
    "([[0-9A-Za-z]#{special_char}]+[\.]+)*[[0-9A-Za-z]#{special_char}+]+"
  end

  # メールアドレスのローカル部において ダブルクウォーテーションで囲まれている部分の正規表現文字列
  #   このままだと文字列ですので、Regexp.new等で正規表現に変換する必要があります
  # @return [String] 正規表現文字列
  def quoted_regexp
    "\"[0-9A-Za-z#{special_char}#{quoted_special_char}\.]*\""
  end

  # メールアドレスのドメイン部の正規表現文字列
  #   このままだと文字列ですので、Regexp.new等で正規表現に変換する必要があります
  # @return [String] 正規表現文字列
  def domain_regexp
    "((\w+\-+[^_])|(\w+\.[-a-z0-9]*))*([-a-z0-9\.]{1,63})\.[a-z]{2,6}(?:\.[a-z]{2,6})?"
  end
end

