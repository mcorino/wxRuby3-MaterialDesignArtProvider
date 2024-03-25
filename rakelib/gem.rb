###
# wxRuby3/Shapes rake gem support
# Copyright (c) M.J.N. Corino, The Netherlands
###

require 'set'
require 'rubygems'
require 'rubygems/package'
begin
  require 'rubygems/builder'
rescue LoadError
end

require_relative './lib/config'

module WXRuby3MDArt

  module Gem

    def self.manifest
      # create MANIFEST list with included files
      manifest = Rake::FileList.new
      manifest.include %w[assets/**/* lib/**/*.rb samples/**/* tests/**/*]
      manifest.include 'rakelib/yard/**/*'
      manifest.include %w{LICENSE README.md CREDITS.md Apache2.0-LICENSE CC01.0-LICENSE.md CCBY4.0-LICENSE .yardopts}
      manifest
    end

    def self.define_spec(name, version, &block)
      gemspec = ::Gem::Specification.new(name, version)
      gemspec.required_rubygems_version = ::Gem::Requirement.new(">= 0") if gemspec.respond_to? :required_rubygems_version=
      block.call(gemspec) if block_given?
      gemspec
    end

    def self.gem_name(name, version)
      define_spec(name, version).full_name
    end

    def self.gem_file(name, version)
      File.join('pkg', "#{WXRuby3MDArt::Gem.gem_name(name, version)}.gem")
    end

    def self.build_gem(gemspec)
      if defined?(::Gem::Package) && ::Gem::Package.respond_to?(:build)
        gem_file_name = ::Gem::Package.build(gemspec)
      else
        gem_file_name = ::Gem::Builder.new(gemspec).build
      end

      FileUtils.mkdir_p('pkg')

      FileUtils.mv(gem_file_name, 'pkg')
    end

  end

end
