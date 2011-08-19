# PrivacyMaskTools

個人情報らしきものを判定・マスキングします

## install

<pre><code>gem 'privacy_mask_tools'</code></pre>

## How to use

<pre><code>PrivacyMaskTools::Base.has_mobile_number?("090-1234-5678")
# => true
PrivacyMaskTools::Base.mobile_number_masking("私の携帯電話番号は 090-1234-5678 です")
# => "私の携帯電話番号は ***-****-**** です"
</code></pre>

## You can include PrivacyMaskTools methods in your object

in your object
<pre><code>class Obj
  include PrivacyMaskTools::Matcher
  # ... todo something
end</code></pre>

<pre><code>x = Obj.new
x.mobile_number_masking</code></pre>

## Copyright

Copyright (c) 2011 NAMAKESUGI, released under the MIT license
