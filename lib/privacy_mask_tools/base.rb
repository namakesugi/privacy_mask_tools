# coding: utf-8

# PrivacyMaskTools::Matcherをincludeしselfで使用できるようにしています
# @example
#   PrivacyMaskTools::Base.mobile_number_masking("#{target_text}")
class PrivacyMaskTools::Base
  class << self
    include PrivacyMaskTools::Matcher
  end
end

