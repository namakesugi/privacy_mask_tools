guard 'rspec', version: 2, cli: '--color --format nested --fail-fast', all_on_start: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/privacy_mask_tools/(.+)\.rb$})     { |m| "spec/privacy_mask_tools/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec/" }
  watch('lib/privacy_mask_tools.rb') { "spec/" }
end

