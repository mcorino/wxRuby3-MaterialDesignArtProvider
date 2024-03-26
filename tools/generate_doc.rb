
require 'wx/core'
require 'wx/mdap'

require 'fileutils'
require 'base64'

# determine doc folder path
mdap_folder = File.expand_path(File.join(__dir__, '..', 'lib', 'wx', 'mdap'))
doc_folder = File.join(mdap_folder, 'doc')
# make sure the doc folder exists
FileUtils.mkdir_p(doc_folder)
# write constants doc
File.open(File.join(doc_folder, 'mdap.rb'), "w+") do |fdoc|

  fdoc << <<~__HEREDOC
    # :stopdoc:
    # This file is automatically generated by the WXRuby3 documentation 
    # generator. Do not alter this file.
    # :startdoc:
    
    
    module Wx

      module MDAP

        # @!group Art Client Id Constants

  __HEREDOC

  Wx::MDAP.all_art_clients.each do |sym|
    case sym
    when :ART_FONT_AWESOME_BRANDS, :ART_SIMPLE_ICONS_ICONS
      fdoc.puts "    # MaterialDesignArtProvider only provides (brand-)specific icons for this art client."
      fdoc.puts "    # No standard ArtId mappings are provided."
    else
      fdoc.puts "    # MaterialDesignArtProvider provides standard ArtId mappings for this art client (see {file:STANDARD-Art-Mappings.md})."
    end
    fdoc.puts '    #'
    fdoc.puts "    # See {file:#{Wx::MDAP.art_group_for_client(sym)}-Art.md} for an overview of provided icons."
    fdoc.puts "    #{sym} = _"
    fdoc.puts
  end

  fdoc << <<~__HEREDOC

    # @!endgroup

    # @!group Art Id Constants

  __HEREDOC

  Wx::MDAP.all_art_ids.each do |sym|

    fdoc.puts '    # Available for :'
    fdoc.puts '    #'
    Wx::MDAP.all_art_clients.each do |clt|
      if Wx::MDAP.has_art_id?(Wx::MDAP.const_get(clt), Wx::MDAP.const_get(sym))
        fdoc.puts "    # - {file:#{Wx::MDAP.art_group_for_client(clt)}-Art.md\##{sym} #{clt}}"
      end
    end
    fdoc.puts '    #'
    fdoc.puts "    #{sym} = _"

  end

  fdoc << <<~__HEREDOC

        # @!endgroup

      end

    end
  __HEREDOC

end

# write art client group overview tables
Wx::MDAP.art_client_group_ids.each do |art_group|
  File.open(File.join(doc_folder, "#{art_group}-Art.md"), "w+") do |fdoc|
    fdoc << <<~__HEREDOC
      # Material Design #{art_group} Art Overview
  
      | Art Id | #{Wx::MDAP.art_client_ids_for_group(art_group).collect(&:to_s).join(' | ')} |
    __HEREDOC
    fdoc.print('|---|')
    Wx::MDAP.art_client_ids_for_group(art_group).size.times { fdoc.print('---|') }
    fdoc.puts
    Wx::MDAP.get_art_ids_for_group(art_group).each do |sym|
      fdoc.print("| `Wx::MDAP::#{sym}`{:\##{sym}} |")
      Wx::MDAP.art_client_ids_for_group(art_group).each do |clt|
        svg = Wx::MDAP.art_for(Wx::MDAP.const_get(clt), Wx::MDAP.const_get(sym))
        if svg
          fdoc.print " ![svg](data:image/svg+xml;base64,#{Base64.strict_encode64(File.read(svg))}){:height=\"32px\" :width=\"32px\"} |"
        else
          fdoc.print('  |')
        end
      end
      fdoc.puts
    end
  end
end

# Write standard ArtId mapping overview table
File.open(File.join(doc_folder, "STANDARD-Art-Mappings.md"), "w+") do |fdoc|
  mapped_clients = Wx::MDAP.get_all_art_clients - %i[ART_FONT_AWESOME_BRANDS ART_SIMPLE_ICONS_ICONS]
  std_art_ids = %i[
    ART_ERROR ART_QUESTION ART_WARNING ART_INFORMATION ART_ADD_BOOKMARK ART_DEL_BOOKMARK
    ART_HELP_SIDE_PANEL ART_HELP_SETTINGS ART_HELP_BOOK ART_HELP_FOLDER ART_HELP_PAGE
    ART_GO_BACK ART_GO_FORWARD ART_GO_UP ART_GO_DOWN ART_GO_TO_PARENT ART_GO_HOME ART_GOTO_FIRST ART_GOTO_LAST
    ART_PRINT ART_HELP ART_TIP ART_REPORT_VIEW ART_LIST_VIEW ART_NEW_DIR ART_FOLDER ART_FOLDER_OPEN
    ART_GO_DIR_UP ART_EXECUTABLE_FILE ART_NORMAL_FILE ART_TICK_MARK ART_CROSS_MARK ART_MISSING_IMAGE
    ART_NEW ART_FILE_OPEN ART_FILE_SAVE ART_FILE_SAVE_AS
    ART_DELETE ART_COPY ART_CUT ART_PASTE ART_UNDO ART_REDO
    ART_PLUS ART_MINUS
    ART_CLOSE ART_QUIT ART_FIND ART_FIND_AND_REPLACE
    ART_FULL_SCREEN ART_EDIT
    ART_HARDDISK ART_FLOPPY ART_CDROM ART_REMOVABLE ART_STOP ART_REFRESH]
  fdoc << <<~__HEREDOC
    # Material Design Standard ArtId mapping Overview

    | Art Id | #{mapped_clients.collect(&:to_s).join(' | ')} |
  __HEREDOC
  fdoc.print('|---|')
  mapped_clients.size.times { fdoc.print('---|') }
  fdoc.puts
  std_art_ids.each do |sym|
    fdoc.print("| `Wx::#{sym}` |")
    mapped_clients.each do |clt|
      svg = Wx::MDAP.art_for(Wx::MDAP.const_get(clt), Wx.const_get(sym))
      if svg
        fdoc.print " ![svg](data:image/svg+xml;base64,#{Base64.strict_encode64(File.read(svg))}){:height=\"32px\" :width=\"32px\"} |"
      else
        $stderr.puts "Missing Wx::MDAP::#{clt}[Wx::#{sym}]"
        fdoc.print('  |')
      end
    end
    fdoc.puts
  end
end
