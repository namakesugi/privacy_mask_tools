# coding: utf-8

# Email判定用モジュール
module PrivacyMaskTools::EmailMatcher

  # RFC 2822 と RFC 3696 に対応した正規表現を生成します
  #   概ね対応しているレベルであり、完全に対応しているわけではありません
  #
  # validates_email_format_ofを参考にしています
  # @see https://github.com/alexdunae/validates_email_format_of
  # TODO chache
  def make_rfc_regexp
    special  = Regexp.escape('!#$%&\'*-/=?+-^_`{|}~')
    quoted_special = Regexp.escape('()<>[]:;@, ')
    unquoted = "([[0-9A-Za-z]#{special}]+[\.]+)*[[0-9A-Za-z]#{special}+]+"
    quoted   = "\"[0-9A-Za-z#{special}#{quoted_special}\.]*\""
    domain   = "((\w+\-+[^_])|(\w+\.[-a-z0-9]*))*([-a-z0-9\.]{1,63})\.[a-z]{2,6}(?:\.[a-z]{2,6})?"
    Regexp.new('(('+ unquoted + '|' + quoted + '+)@(' + domain + '))')
  end

  def has_rfc_email?(text)
    !text.match(make_rfc_regexp).nil?
  end

  def pick_rfc_email(text)
    [].tap { |o|
      text.scan(make_rfc_regexp) { |f| o << f[0] }
    }
  end

  def has_email?(text, jargon=false)
  end

  def has_mobile_email?(text, jargon=false)
  end

  def email_masking(text, word='*', jargon=false)
  end

  def mobile_email_masking(text, word='*', jargon=false)
  end
end

