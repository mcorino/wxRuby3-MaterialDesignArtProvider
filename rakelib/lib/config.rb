###
# wxRuby3/MDAP rake configuration
# Copyright (c) M.J.N. Corino, The Netherlands
###

module WXRuby3MDAP
  ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

  # Ruby 2.5 is the minimum version for wxRuby3/MDAP
  __rb_ver = RUBY_VERSION.split('.').collect {|v| v.to_i}
  if (__rb_major = __rb_ver.shift) < 2 || (__rb_major == 2 && __rb_ver.shift < 5)
    STDERR.puts 'ERROR: wxRuby3/MDAP requires Ruby >= 2.5.0!'
    exit(1)
  end

  # Pure-ruby lib files
  ALL_RUBY_LIB_FILES = FileList[ 'lib/**/*.rb' ]

  # The version file
  VERSION_FILE = File.join(ROOT,'lib', 'wx', 'mdap', 'version.rb')

  if File.exist?(VERSION_FILE)
    require VERSION_FILE
    WX_MDAP_VERSION = Wx::MDAP::VERSION
    # Leave version undefined
  else
    WX_MDAP_VERSION = ''
  end

end # module WXRuby3MDAP
