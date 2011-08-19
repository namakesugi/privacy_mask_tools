# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "privacy_mask_tools/version"

Gem::Specification.new do |s|
  s.name        = "privacy_mask_tools"
  s.version     = PrivacyMaskTools::VERSION
  s.authors     = ["namakesugi"]
  s.email       = ["info@namakesugi.net"]
  s.homepage    = ""
  s.summary     = %q{privacy data masking tools for japanese}
  s.description = %q{Included methods "has_mobile_number?", "mobile_number_masking"}

  s.rubyforge_project = "privacy_mask_tools"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec', '~> 2.6.0'
  s.add_development_dependency 'tapp', '~> 1.0.0'
end

