###
# wxRuby3/MDArt rake file
# Copyright (c) M.J.N. Corino, The Netherlands
###

module WXRuby3MDArt
  HELP = <<__HELP_TXT

wxRuby3/MDArt Rake based build system
--------------------------------------

This build system provides commands for testing and installing wxRuby3/MDArt.

commands:

rake <rake-options> help             # Provide help description about wxRuby3/MDArt build system
rake <rake-options> gem              # Build wxruby3-md_art gem
rake <rake-options> test             # Run all wxRuby3/MDArt tests
rake <rake-options> package          # Build all the packages
rake <rake-options> repackage        # Force a rebuild of the package files
rake <rake-options> clobber_package  # Remove package products

__HELP_TXT
end

namespace :wxruby_md_art do
  task :help do
    puts WXRuby3MDArt::HELP
  end
end

desc 'Provide help description about wxRuby3/MDArt build system'
task :help => 'wxruby_md_art:help'
