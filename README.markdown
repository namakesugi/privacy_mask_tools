# PrivacyMaskTools

個人情報らしきものを判定・マスキングします

## install

<pre><code>gem 'privacy_mask_tools'</code></pre>

## How to use

<pre><code>PrivacyMaskTools::Base.has_mobile_number?("090-1234-5678")
# => true
PrivacyMaskTools::Base.mobile_number_masking("私の携帯電話番号は 090-1234-5678 です")
# => "私の携帯電話番号は ***-****-**** です"
PrivacyMaskTools::Base.pick_mobile_number("私の携帯電話番号は 090-1234-5678 です")
# => ["090-1234-5678"]
</code></pre>

## Module Infomation

### PrivacyMaskTools::PhoneMatcher

* has_mobile_number?
* has_phone_number?
* mobile_number_masking
* phone_nomber_masking
* pick_mobile_number
* pick_phone_number

### PrivacyMaskTools::EmailMatcher

* has_rfc_email?("<text data>") # => return true or false
* pick_rfc_email("<text data>") # => return Array
* rfc_email_masking("<text data>", "<masking words>") # => return masked text_data

## You can include PrivacyMaskTools methods in your object

in your object
<pre><code>class Obj
  include PrivacyMaskTools::PhoneMatcher
  include PrivacyMaskTools::EmailMatcher
  # ... todo something
end</code></pre>

<pre><code>x = Obj.new
x.has_mobile_number?("080-0000-0000")
# => true
x.has_rfc_email?("xxxx@example.com")
# => true</code></pre>

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 NAMAKESUGI, released under the MIT license

