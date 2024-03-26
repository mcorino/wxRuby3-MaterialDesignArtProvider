###
# wxRuby3/MDAP rake file
# Copyright (c) M.J.N. Corino, The Netherlands
###

module WXRuby3MDAP
  HELP = <<__HELP_TXT

wxRuby3/MDAP Rake based build system
--------------------------------------

This build system provides commands for testing and installing wxRuby3/MDAP.

commands:

rake <rake-options> help             # Provide help description about wxRuby3/MDAP build system
rake <rake-options> gem              # Build wxruby3-mdap gem
rake <rake-options> test             # Run all wxRuby3/MDAP tests
rake <rake-options> package          # Build all the packages
rake <rake-options> repackage        # Force a rebuild of the package files
rake <rake-options> clobber_package  # Remove package products

__HELP_TXT
end

namespace :wxruby_mdap do
  task :help do
    puts WXRuby3MDAP::HELP
  end
end

desc 'Provide help description about wxRuby3/MDAP build system'
task :help => 'wxruby_mdap:help'
