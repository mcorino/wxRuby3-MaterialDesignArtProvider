###
# wxRuby3/MDAP rake file
# Copyright (c) M.J.N. Corino, The Netherlands
###

require_relative './gem'

namespace :wxruby_mdap do

  task :gem => WXRuby3MDAP::Gem.gem_file('wxruby3-mdap', WXRuby3MDAP::WX_MDAP_VERSION)

end

# source gem file
file WXRuby3MDAP::Gem.gem_file('wxruby3-mdap', WXRuby3MDAP::WX_MDAP_VERSION) => WXRuby3MDAP::Gem.manifest do
  gemspec = WXRuby3MDAP::Gem.define_spec('wxruby3-mdap', WXRuby3MDAP::WX_MDAP_VERSION) do |gem|
    gem.summary = %Q{wxRuby3 Material Design Art Provider}
    gem.description = %Q{wxRuby3/MDAP is a pure Ruby library providing a custom ArtProvider for using MaterialDesign bitmaps and icons in wxRuby3}
    gem.email = 'mcorino@m2c-software.nl'
    gem.homepage = "https://github.com/mcorino/wxRuby3-MaterialDesignArtProvider"
    gem.authors = ['Martin Corino']
    gem.files = WXRuby3MDAP::Gem.manifest
    gem.require_paths = %w{lib}
    gem.required_ruby_version = '>= 2.5'
    gem.licenses = ['MIT']
    gem.add_dependency 'wxruby3', '~> 1.0'
    gem.metadata = {
      "bug_tracker_uri"   => "https://github.com/mcorino/wxRuby3-MaterialDesignArtProvider/issues",
      "documentation_uri" => "https://mcorino.github.io/wxRuby3-MaterialDesignArtProvider",
      "homepage_uri"      => "https://github.com/mcorino/wxRuby3-MaterialDesignArtProvider",
      "github_repo"       => "https://github.com/mcorino/wxRuby3-MaterialDesignArtProvider"
    }
    gem.post_install_message = <<~__MSG

      wxRuby3/MDAP has been successfully installed.

      Have fun using wxRuby3/MDAP.
      __MSG
  end
  WXRuby3MDAP::Gem.build_gem(gemspec)
end

desc 'Build wxruby3-mdap gem'
task :gem => 'wxruby_mdap:gem'
