###
# wxRuby3/MDAP rake file
# Copyright (c) M.J.N. Corino, The Netherlands
###

require 'rake/packagetask'

Rake::PackageTask.new("wxruby3-mdap", WXRuby3MDAP::WX_MDAP_VERSION) do |p|
  p.need_tar_gz = true
  p.need_zip = true
  p.package_files.include(%w{assets/**/* samples/**/* lib/**/* tests/**/* rakelib/**/*})
  p.package_files.include(%w{INSTALL* LICENSE* Gemfile rakefile README.md CREDITS.md .yardopts})
end
