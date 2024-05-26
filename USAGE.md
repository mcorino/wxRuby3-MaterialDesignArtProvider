
# Using Material Design Art Provider for wxRuby3

The following example shows how to use [Wx::MDAP::MaterialDesignArtProvider](https://mcorino.github.io/wxRuby3-MaterialDesignArtProvider/Wx/MDAP/MaterialDesignArtProvider.html)
in a wxRuby3 application.

This example can be run with or without using [Wx::MDAP::MaterialDesignArtProvider](https://mcorino.github.io/wxRuby3-MaterialDesignArtProvider/Wx/MDAP/MaterialDesignArtProvider.html).<br>
When using [Wx::MDAP::MaterialDesignArtProvider](https://mcorino.github.io/wxRuby3-MaterialDesignArtProvider/Wx/MDAP/MaterialDesignArtProvider.html) the example also demonstrates how to optionally use custom default icon
sizes and colours.

The following commandline switches are available to enable or disable options:

- `-u|--use-mdap`<br>directs the example to use [Wx::MDAP::MaterialDesignArtProvider](https://mcorino.github.io/wxRuby3-MaterialDesignArtProvider/Wx/MDAP/MaterialDesignArtProvider.html)
- `-s|--small`<br>directs the example to use small (16x16) Material Design icons
- `-m|--medium`<br>directs the example to use medium (24x24) Material Design icons
- `-l|--large`<br>directs the example to use large (48x48) Material Design icons
- `-cCOLOUR|--colour=COLOUR`<br>directs the example to use `COLOUR` for Material Design icons; `COLOUR` can be specified as a colour name (like `red` or `darkblue`) or CSS (`rgb(r,g,b)`, like `rgb(255,0,0)`, or `rgba(r,g,b,a)` like `rgba(255,0,0,0.333)`) or HTML (`#??????` like `#FF0000`) syntax.

```ruby
# Copyright (c) 2023 M.J.N. Corino, The Netherlands
#
# This software is released under the MIT license.

require 'wx'
require 'wx/mdap'
require 'optparse'

class TestFrame < Wx::Frame
  def initialize(mdap = false)
    super(nil, title: "Frame #{mdap ? 'with' : 'without'} MaterialDesignArtProvider",
          size: [600, 400])

    # Create the menu
    
    # To be able to optionally override system default icon mappings for stock ids like ID_NEW/ID_OPEN/ID_SAVE etc.
    # you need to explicitly set a bitmap for a menu item using Wx::ArtProvider and the standard Art Ids
    # matching these stock ids.
    # This way a custom art provider mapping the standard Art Ids like Wx::MDAP::MaterialDesignArtProvider can
    # override standard mappings if installed.

    menuFile = Wx::Menu.new
    mi = Wx::MenuItem.new(menuFile, Wx::StandardID::ID_NEW, 'New')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_NEW, Wx::ART_MENU))
    menuFile.append(mi)
    mi = Wx::MenuItem.new(menuFile, Wx::StandardID::ID_OPEN, 'Open')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_FILE_OPEN, Wx::ART_MENU))
    menuFile.append(mi)
    mi = Wx::MenuItem.new(menuFile, Wx::StandardID::ID_SAVE, 'Save')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_FILE_SAVE, Wx::ART_MENU))
    menuFile.append(mi)
    mi = Wx::MenuItem.new(menuFile, Wx::StandardID::ID_SAVEAS, 'Save as...')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_FILE_SAVE_AS, Wx::ART_MENU))
    menuFile.append(mi)
    menuFile.append_separator
    mi = Wx::MenuItem.new(menuFile, Wx::StandardID::ID_REFRESH, 'Refresh')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_REFRESH, Wx::ART_MENU))
    menuFile.append(mi)
    menuFile.append_separator
    mi = Wx::MenuItem.new(menuFile, Wx::StandardID::ID_PRINT, 'Print...')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_PRINT, Wx::ART_MENU))
    menuFile.append(mi)
    menuFile.append_separator
    mi = Wx::MenuItem.new(menuFile, Wx::StandardID::ID_CLOSE, 'Close')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_CLOSE, Wx::ART_MENU))
    menuFile.append(mi)

    menuEdit = Wx::Menu.new
    mi = Wx::MenuItem.new(menuEdit, Wx::StandardID::ID_CUT, 'Cut')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_CUT, Wx::ART_MENU))
    menuEdit.append(mi)
    mi = Wx::MenuItem.new(menuEdit, Wx::StandardID::ID_COPY, 'Copy')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_COPY, Wx::ART_MENU))
    menuEdit.append(mi)
    mi = Wx::MenuItem.new(menuEdit, Wx::StandardID::ID_PASTE, 'Paste')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_PASTE, Wx::ART_MENU))
    menuEdit.append(mi)
    mi = Wx::MenuItem.new(menuEdit, Wx::StandardID::ID_DELETE, 'Delete')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_DELETE, Wx::ART_MENU))
    menuEdit.append(mi)
    menuEdit.append_separator
    mi = Wx::MenuItem.new(menuEdit, Wx::StandardID::ID_UNDO, 'Undo')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_UNDO, Wx::ART_MENU))
    menuEdit.append(mi)
    mi = Wx::MenuItem.new(menuEdit, Wx::StandardID::ID_REDO, 'Redo')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_REDO, Wx::ART_MENU))
    menuEdit.append(mi)
    menuEdit.append_separator
    mi = Wx::MenuItem.new(menuEdit, Wx::StandardID::ID_FIND, 'Find')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_FIND, Wx::ART_MENU))
    menuEdit.append(mi)
    mi = Wx::MenuItem.new(menuEdit, Wx::StandardID::ID_REPLACE, 'Replace')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_FIND_AND_REPLACE, Wx::ART_MENU))
    menuEdit.append(mi)

    menuHelp = Wx::Menu.new
    mi = Wx::MenuItem.new(menuHelp, Wx::StandardID::ID_ABOUT, 'About')
    mi.set_bitmap(Wx::ArtProvider.get_bitmap(Wx::ART_INFORMATION, Wx::ART_MENU))
    menuHelp.append(mi)

    menuBar = Wx::MenuBar.new
    menuBar.append(menuFile, "&File")
    menuBar.append(menuEdit, "&Edit")
    menuBar.append(menuHelp, "&Help")
    set_menu_bar(menuBar)

    # Create a panel to place the toolbar in (a toolbar could also be attached directly to a Wx::Frame but this
    # has the unfortunate effect, AFAIAC, that on MacOSX it gets integrated in the apps title bar which is not always 
    # pretty). 
    panel = Wx::Panel.new(self)

    panel_szr = Wx::VBoxSizer.new
    
    # Create the toolbar
    tbar = Wx::ToolBar.new(panel, style: Wx::TB_HORIZONTAL | Wx::NO_BORDER | Wx::TB_FLAT)
    tbar.tool_bitmap_size = mdap ? Wx::MDAP::MaterialDesignArtProvider.get_default_size(Wx::ART_TOOLBAR) : [ 16, 16 ]
    tbar.add_tool(Wx::StandardID::ID_NEW, 'New', Wx::ArtProvider.get_bitmap(Wx::ART_NEW, Wx::ART_TOOLBAR), 'Create a new file')
    tbar.add_tool(Wx::StandardID::ID_OPEN, 'New', Wx::ArtProvider.get_bitmap(Wx::ART_FILE_OPEN, Wx::ART_TOOLBAR), 'Open a file')
    tbar.add_tool(Wx::StandardID::ID_SAVE, 'Save', Wx::ArtProvider.get_bitmap(Wx::ART_FILE_SAVE, Wx::ART_TOOLBAR), 'Save the file')
    tbar.add_separator
    tbar.add_tool(Wx::StandardID::ID_UNDO, 'Undo', Wx::ArtProvider.get_bitmap(Wx::ART_UNDO, Wx::ART_TOOLBAR), 'Undo change')
    tbar.add_tool(Wx::StandardID::ID_REDO, 'Redo', Wx::ArtProvider.get_bitmap(Wx::ART_REDO, Wx::ART_TOOLBAR), 'Redo change')
    tbar.add_separator
    tbar.add_tool(Wx::StandardID::ID_COPY, 'Copy', Wx::ArtProvider.get_bitmap(Wx::ART_COPY, Wx::ART_TOOLBAR), 'Copy selection')
    tbar.add_tool(Wx::StandardID::ID_CUT, 'Cut', Wx::ArtProvider.get_bitmap(Wx::ART_CUT, Wx::ART_TOOLBAR), 'Cut selection')
    tbar.add_tool(Wx::StandardID::ID_PASTE, 'Paste', Wx::ArtProvider.get_bitmap(Wx::ART_PASTE, Wx::ART_TOOLBAR), 'Paste selection')
    tbar.add_separator
    tbar.add_tool(Wx::StandardID::ID_FIND, 'Find', Wx::ArtProvider.get_bitmap(Wx::ART_FIND, Wx::ART_TOOLBAR), 'Show Find Dialog')
    tbar.add_tool(Wx::StandardID::ID_REPLACE, 'Replace', Wx::ArtProvider.get_bitmap(Wx::ART_FIND_AND_REPLACE, Wx::ART_TOOLBAR), 'Show Replace Dialog')
    tbar.realize
    
    panel_szr.add(tbar)
    
    panel.set_sizer(panel_szr)
    
    evt_menu(Wx::StandardID::ID_CLOSE) { close(true) }
  end

end

class TestApp < Wx::App
  def initialize
    super
    
    @mdap = false
    @colour = nil
    @size = nil
    
    # parse commandline arguments
    parse_args
  end

  def on_init
    # Setup MaterialDesignArtProvider use if needed
    Wx::ArtProvider.push(Wx::MDAP::MaterialDesignArtProvider.new) if @mdap
    Wx::MDAP::MaterialDesignArtProvider.use_art_colour(@colour) if @mdap && @colour
    Wx::MDAP::MaterialDesignArtProvider.set_default_size(Wx::ART_MENU, @size) if @mdap && @size
    Wx::MDAP::MaterialDesignArtProvider.set_default_size(Wx::ART_TOOLBAR, @size) if @mdap && @size
    
    # create and show the test frame
    TestFrame.new(@mdap).show
  end

  protected

  def parse_args
    opts = OptionParser.new
    opts.on('-u', '--use-mdap',
            'Use MaterialDesignArtProvider') { |v| @mdap = true }
    opts.on('-cCOLOUR', '--colour=COLOUR',
            'Use COLOUR for MaterialDesign art.') { |v| @colour = v }
    opts.on('-s', '--small',
            'Use small size for MaterialDesign art.') { |v| @size = [16,16] }
    opts.on('-m', '--medium',
            'Use medium size for MaterialDesign art.') { |v| @size = [24,24] }
    opts.on('-l', '--large',
            'Use large size for MaterialDesign art.') { |v| @size = [48,48] }
    opts.order!(ARGV) rescue ($stderr.puts "#{$!}\n#{$!.backtrace.join("\n")}"; exit(1))
  end
end

# run the application
TestApp.run
```
