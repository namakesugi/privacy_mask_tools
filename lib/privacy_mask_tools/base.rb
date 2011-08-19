# coding: utf-8

# PrivacyMaskTools::Matcherをincludeしselfで使用できるようにしています
class PrivacyMaskTools::Base
  class << self
    include PrivacyMaskTools::Matcher
  end
end

