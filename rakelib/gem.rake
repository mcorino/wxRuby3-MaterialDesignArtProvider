###
# wxRuby3/MDArt rake file
# Copyright (c) M.J.N. Corino, The Netherlands
###

require_relative './gem'

namespace :wxruby_md_art do

  task :gem => WXRuby3MDArt::Gem.gem_file('wxruby3-md_art', WXRuby3MDArt::WX_MDART_VERSION)

end

# source gem file
file WXRuby3MDArt::Gem.gem_file('wxruby3-md_art', WXRuby3MDArt::WX_MDART_VERSION) => WXRuby3MDArt::Gem.manifest do
  gemspec = WXRuby3MDArt::Gem.define_spec('wxruby3-md_art', WXRuby3MDArt::WX_MDART_VERSION) do |gem|
    gem.summary = %Q{wxRuby3 MaterialDesign icon Art Provider}
    gem.description = %Q{wxRuby3/MDArt is a pure Ruby library providing a custom ArtProvider for using MaterialDesign icons in wxRuby3}
    gem.email = 'mcorino@m2c-software.nl'
    gem.homepage = "https://github.com/mcorino/wxRuby3-MaterialDesignArtProvider"
    gem.authors = ['Martin Corino']
    gem.files = WXRuby3MDArt::Gem.manifest
    gem.require_paths = %w{lib}
    gem.required_ruby_version = '>= 2.5'
    gem.licenses = ['MIT']
    gem.add_dependency 'minitest', '~> 5.15'
    gem.add_dependency 'test-unit', '~> 3.5'
    gem.add_dependency 'wxruby3', '~> 0.9.8'
    gem.metadata = {
      "bug_tracker_uri"   => "https://github.com/mcorino/wxRuby3-MaterialDesignArtProvider/issues",
      "documentation_uri" => "https://mcorino.github.io/wxRuby3-MDArt",
      "homepage_uri"      => "https://github.com/mcorino/wxRuby3-MaterialDesignArtProvider",
    }
    gem.post_install_message = <<~__MSG

      wxRuby3/MDArt has been successfully installed.

      Have fun using wxRuby3/MDArt.
      __MSG
  end
  WXRuby3MDArt::Gem.build_gem(gemspec)
end

desc 'Build wxruby3-md_art gem'
task :gem => 'wxruby_md_art:gem'
