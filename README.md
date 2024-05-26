
# Material Design Art Provider for wxRuby3

This custom Art Provider was inspired by [wxMaterialDesignArtProvider](https://github.com/perazz/wxMaterialDesignArtProvider) 
but rewritten in pure Ruby for use with [wxRuby3](https://github.com/mcorino/wxRuby3).<br>
See the [License](#license) section below to see where the original icons were taken from.

## Installing

wxRuby3-MaterialDesignArtProvider is distributed as a Ruby gem on [RubyGems](https://rubygems.org/). This gem can also 
be downloaded from the release assets on [Github](https://github.com/mcorino/wxRuby3-MaterialDesignArtProvider/releases).

Installing the gem requires no additional installation steps and/or additional software to be installed except for a
supported version of the Ruby interpreter. So the following command is all it takes to install:

```shell
gem install wxruby3-mdap
```

## Using

To add [Wx::MDAP::MaterialDesignArtProvider](https://mcorino.github.io/wxRuby3-MaterialDesignArtProvider/Wx/MDAP/MaterialDesignArtProvider.html) 
to your project you first need to `require` it like this:

```ruby
require 'wx'        # make sure the wxRuby3 libraries have been loaded 
require 'wx/mdap'   # now load the wxRuby3-MaterialDesignArtProvider library
```

Next, before you load images through [Wx::ArtProvider](https://mcorino.github.io/wxRuby3/Wx/ArtProvider.html) register 
the [Wx::MDAP::MaterialDesignArtProvider](https://mcorino.github.io/wxRuby3-MaterialDesignArtProvider/Wx/MDAP/MaterialDesignArtProvider.html) like this:

```ruby
Wx::ArtProvider.push(Wx::MDAP::MaterialDesignArtProvider.new)
# You can in fact normally also reference the class as `Wx::MaterialDesignArtProvider` (unless the constant 
# `Wx::MaterialDesignArtProvider` was already defined before requiring 'wx/mdap').
```

Now that the new art provider has been installed the new Material Design art ids can be used. Constants for these are
all defined in the `Wx::MDAP` module as 'Wx::MDAP::ART_*ICON_NAME*' (see [here](https://mcorino.github.io/wxRuby3-MaterialDesignArtProvider/Wx/MDAP.html)).
Many of these art ids are available under most of the various client ids (also defined [here](https://mcorino.github.io/wxRuby3-MaterialDesignArtProvider/Wx/MDAP.html))
while others are only available under some client ids (as can be seen in the documentation).
The client ids each correspond to a different collection in the full dataset: 

- **Material Design** art
  - `Wx::MDAP::ART_MATERIAL_DESIGN_FILLED`
  - `Wx::MDAP::ART_MATERIAL_DESIGN_OUTLINE`
  - `Wx::MDAP::ART_MATERIAL_DESIGN_ROUND`
  - `Wx::MDAP::ART_MATERIAL_DESIGN_SHARP`
  - `Wx::MDAP::ART_MATERIAL_DESIGN_TWO_TONE`
- **Font Awesome** art
  - `Wx::MDAP::ART_FONT_AWESOME_SOLID`
  - `Wx::MDAP::ART_FONT_AWESOME_REGULAR`
  - `Wx::MDAP::ART_FONT_AWESOME_BRANDS`
- **Fluent UI** art
  - `Wx::MDAP::ART_FLUENT_UI_FILLED`
  - `Wx::MDAP::ART_FLUENT_UI_REGULAR`
- **Simple Icons** art
  - `Wx::MDAP::ART_SIMPLE_ICONS_ICONS`

Of these collections, `Wx::MDAP::ART_FONT_AWESOME_BRANDS` and `Wx::MDAP::ART_SIMPLE_ICONS_ICONS` are the odd
ones out as these do not contain any action/function icons but rather brand/logo icons. 

### Extensions

wxRuby3-MaterialDesignArtProvider offers several extensions to improve options for using the Material Design art:

1. `Wx::MDAP::MaterialDesignArtProvider` supports mapping of standard wxRuby3 Art (Client) ids to Material Design ids so 
   you can transparently switch standard art;
2. `Wx::MDAP::MaterialDesignArtProvider` supports using custom colors with Material Design art;
3. `Wx::MDAP::MaterialDesignArtProvider` supports using custom default sizes with Material Design art.

See [Wx::MDAP::MaterialDesignArtProvider](https://mcorino.github.io/wxRuby3-MaterialDesignArtProvider/Wx/MDAP/MaterialDesignArtProvider.html)
for details concerning these extensions.

### Example

For more details and a working example of how to use [Wx::MDAP::MaterialDesignArtProvider](https://mcorino.github.io/wxRuby3-MaterialDesignArtProvider/Wx/MDAP/MaterialDesignArtProvider.html)
see [here](USAGE.md).

## License

- FontAwesome icons from the FontAwesome 6 SVG set are subject to the [CC BY 4.0 License](CCBY4.0-LICENSE)<br>
  (the included icons have been copied from https://github.com/FortAwesome/Font-Awesome)
- MaterialDesign icons are created by Google and subject to the [Apache 2.0 License](Apache2.0-LICENSE)<br>
  (the included SVG icons have been copied from https://github.com/marella/material-design-icons)
- SimpleIcons are subject to the [CC0 1.0 License](CC01.0-LICENSE.md)<br>
  (the included icons haven been copied from https://github.com/simple-icons/simple-icons)
- FluentUI icons are subject to the [MIT License](LICENSE)<br>
  (included SVG icons taken from [FluentUI icons](https://github.com/microsoft/fluentui-system-icons))

The wxRuby3 MaterialDesignArtProvider library itself is released under the [MIT License](LICENSE).
