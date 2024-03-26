# Copyright (c) 2023 M.J.N. Corino, The Netherlands
#
# This software is released under the MIT license.


module Wx

  module MDAP

    # Material Design art provider class.
    #
    # This derived {https://mcorino.github.io/wxRuby3/Wx/ArtProvider.html Wx::ArtProvider} class implements all
    # required overrides to support the full functionality of `Wx::ArtProvider` to access a set of Material Design
    # SVG Art consisting of nearly 9000 images distributed over 11 lists from Fluent UI, Font Awesome, Material Design
    # and Simple Icons collections (see the {file:README.md} for more information).<br>
    #
    # ## Identifying art resources
    #
    # Each list from these collections has been mapped to a distinct Art Client id and for each image a distinct
    # Art id has been defined.<br>
    # See {Wx::MDAP here} for all defined Art (Client) id constants.<br>
    #
    # ## Art overviews
    #
    # Overviews of the available icons for the various Art Client id/Art id combinations can be found at the
    # following locations:
    #
    # - {file:FLUENT_UI-Art.md Fluent UI art}
    # - {file:FONT_AWESOME-Art.md Font Awesome art}
    # - {file:MATERIAL_DESIGN-Art.md Material Design art}
    # - {file:SIMPLE_ICONS-Art.md Simple Icons art}
    #
    # ## Extensions
    #
    # The MaterialDesignArtProvider class provides a number of extensions to customize the default colour and default
    # size for MaterialDesignArtProvider returned images as well a mapping scheme for standard wxRuby3 Art (Client) ids
    # to MaterialDesignArtProvider specific ids.
    #
    # ### Managing Art colour
    #
    # By default MaterialDesignArtProvider will return images in the colour as defined in the original SVG which is
    # usually BLACK.
    # This can be overridden by using either of 2 methods; {.use_art_colour} and/or {.with_art_colour}.
    #
    # ### Managing Art size
    #
    # When requesting images from MaterialDesignArtProvider with `Wx::DEFAULT_SIZE` by default the size used will be
    # derived from {https://mcorino.github.io/wxRuby3/Wx/ArtProvider.html#get_native_size_hint-class_method Wx::ArtProvider.get_native_size_hint}.
    # In case this returns `Wx::DEFAULT_SIZE` itself the default will be `Wx::Size.new(24,24)`.
    # This can be overridden by using {.set_default_size}. Use {.get_default_size} to see what the current default size
    # will be.
    #
    # ### Mapping standard wxRuby3 Art ids
    #
    # MaterialDesignArtProvider implements a **fixed** mapping scheme for mapping standard wxRuby3 Art ids (like
    # `Wx::ART_ERROR`, `Wx::FILE_SAVE`, `Wx::ART_FOLDER` etc.) to MaterialDesignArtProvider Art ids (defined in {Wx::MDAP}).
    # An overview of this mapping scheme can be found {file:STANDARD-Art-Mappings.md  here}.<br>
    # In addition to that MaterialDesignArtProvider implements a customizable mapping scheme for mapping standard
    # wxRuby3 Art Client ids (like `Wx::ART_MENU`, `Wx::ART_TOOLBAR`, `Wx::ART_OTHER` etc.) to MaterialDesignArtProvider
    # Art Client ids (defined in {Wx::MDAP}).
    # By default all standard Art Client ids are mapped to {Wx::MDAP::ART_FLUENT_UI_REGULAR}. This can be overridden by
    # using {.map_std_client_id}.
    #
    class MaterialDesignArtProvider < Wx::ArtProvider

      class << self

        private

        # Returns the current default Material Design Art colour
        # (default `nil` meaning to use the SVG images 'as-is')
        def art_colour
          @art_colour
        end

        # (Re)Sets the default Material Design Art colour
        def set_art_colour(colour)
          @art_colour = if colour.is_a?(Wx::Colour)
                          colour
                        else
                          colour ? Wx::Colour.new(colour) : nil
                        end
        end

        # Returns the registry of the default sizes for each Material Design Art client
        def default_sizes
          @def_sizes ||= {}
        end

        # Returns a list of the standard wxRuby3 Art Client ids
        def std_client_ids
          @std_client_ids ||= [
            Wx::ART_TOOLBAR,
            Wx::ART_MENU,
            Wx::ART_BUTTON,
            Wx::ART_FRAME_ICON,
            Wx::ART_CMN_DIALOG,
            Wx::ART_HELP_BROWSER,
            Wx::ART_MESSAGE_BOX,
            Wx::ART_OTHER]
        end

        # Returns the registry mapping standard wxRuby3 Art Client ids to Material Design Art Client ids.
        # If no mapping specified the default mapping will be {Wx::MDAP::ART_FLUENT_UI_REGULAR}
        def std_client_id_map
          @std_client_id_map ||= ::Hash.new(Wx::MDAP::ART_FLUENT_UI_REGULAR)
        end

        public

        # Sets the active colour to use for created MaterialDesign art.
        # By default the colour is `nil` (which is equivalent to :BLACK).
        # @param [Wx::Colour,String,Symbol,nil] colour
        def use_art_colour(colour)
          set_art_colour(colour)
        end

        # Sets the active colour to use for created MaterialDesign art in the scope of the given block.
        # After the block returns the colour is restored to it's setting from before the block.
        # @param [Wx::Colour,String,Symbol,nil] colour
        def with_art_colour(colour)
          prev_colour = art_colour
          begin
            set_art_colour(colour)
            yield if block_given?
          ensure
            set_art_colour(prev_colour)
          end
        end

        # Returns the default art size for the given Material Design Art Client id.
        # By default will derive default from {Wx::ArtProvider.get_native_size_hint}.
        # @param [String] client Art Client id
        # @return [Wx::size]
        def get_default_size(client)
          raise ArgumentError, "Invalid Material Design art client id [#{client}]" unless MDAP.has_art_client_id?(client)
          unless default_sizes.has_key?(client)
            def_sz = Wx::ArtProvider.get_native_size_hint(client)
            default_sizes[client] = (def_sz == Wx::DEFAULT_SIZE ? Wx::Size.new(24,24) : def_sz)
          end
          default_sizes[client]
        end

        # Sets the default art size for the given Material Design Art Client id.
        # @param [String] client Art Client id
        # @param [Wx::Size,Array(Integer,Integer)] size
        def set_default_size(client, size)
          raise ArgumentError, "Invalid Material Design art client id [#{client}]" unless MDAP.has_art_client_id?(client)
          default_sizes[client] = size.to_size
        end

        # Sets the MDAP client id to use when a std wxRuby3 ClientArtId is passed to {MaterialDesignArtProvider}.
        # By default the alternative id used for any standard id is {Wx::MDAP::ART_FLUENT_UI_REGULAR}.
        # The `std_client_id` passed should be one of:
        #
        # - {Wx::ART_TOOLBAR}
        # - {Wx::ART_MENU}
        # - {Wx::ART_BUTTON}
        # - {Wx::ART_FRAME_ICON}
        # - {Wx::ART_CMN_DIALOG}
        # - {Wx::ART_HELP_BROWSER}
        # - {Wx::ART_MESSAGE_BOX}
        # - {Wx::ART_OTHER}
        #
        # The `md_client_id` passed should be one of:
        #
        # - {Wx::MDAP::ART_FLUENT_UI_REGULAR}
        # - {Wx::MDAP::ART_FLUENT_UI_FILLED}
        # - {Wx::MDAP::ART_FONT_AWESOME_REGULAR}
        # - {Wx::MDAP::ART_FONT_AWESOME_SOLID}
        # - {Wx::MDAP::ART_MATERIAL_DESIGN_FILLED}
        # - {Wx::MDAP::ART_MATERIAL_DESIGN_OUTLINED}
        # - {Wx::MDAP::ART_MATERIAL_DESIGN_ROUND}
        # - {Wx::MDAP::ART_MATERIAL_DESIGN_SHARP}
        # - {Wx::MDAP::ART_MATERIAL_DESIGN_TWO_TONE}
        #
        # @param [String] std_client_id the standard client id to map
        # @param [String] md_client_id the alternative Material Design client id to use
        def map_std_client_id(std_client_id, md_client_id)
          raise ArgumentError, "Invalid standard art client id [#{std_client_id}]" unless std_client_ids.include?(std_client_id)
          raise ArgumentError, "Invalid Material Design art client id [#{md_client_id}]" unless MDAP.has_art_client_id?(md_client_id)
          std_client_id_map[std_client_id] = md_client_id
        end

      end

      protected

      def create_bitmap(id, client, size)
        # create bundle and get bitmap from it
        bundle = create_bitmap_bundle(id, client, size)
        return Wx::NULL_BITMAP unless bundle.ok?
        bmp = bundle.get_bitmap(size)
        bmp.ok? ? bmp : Wx::NULL_BITMAP
      end

      def create_bitmap_bundle(id, client, size)
        # map standard wxRuby3 client ids
        if MaterialDesignArtProvider.std_client_ids.include?(client)
          client = MaterialDesignArtProvider.std_client_id_map[client]
        end
        art_path = MDAP.get_art_for(client, id)
        return Wx::NULL_BITMAP unless art_path
        size = size.to_size # make sure to have a Wx::Size
        size = MaterialDesignArtProvider.get_default_size(client) if size == Wx::DEFAULT_SIZE
        if (art_clr = MaterialDesignArtProvider.__send__(:art_colour))
          svg_data = change_svg_colour(File.read(art_path), art_clr)
          Wx::BitmapBundle.from_svg(svg_data, size)
        else
          # create bundle
          Wx::BitmapBundle.from_svg_file(art_path, size)
        end
      end

      def create_icon_bundle(id, client)
        bundle = create_bitmap_bundle(id, client, size = MaterialDesignArtProvider.get_default_size(client))
        Wx::IconBundle.new(bundle.get_icon(size))
      end

      private

      # @api private
      FILL_RE = /fill="#(?:[0-9a-fA-F]{3,4}){1,2}"/
      # @api private
      PATH_RE = /<path\s/

      def change_svg_colour(svg_data, colour)
        # see if we can replace the path colours
        rc = svg_data.gsub!(FILL_RE, "fill=\"#{colour.get_as_string(Wx::C2S_HTML_SYNTAX)}\"")
        # if any replaced we're done
        return svg_data if rc
        # insert colour to every <path ...>
        svg_data.gsub!(PATH_RE, "<path fill=\"#{colour.get_as_string(Wx::C2S_HTML_SYNTAX)}\"")
        svg_data
      end

    end

  end

  # Import MaterialDesignArtProvider in Wx namespace if possible
  MaterialDesignArtProvider = MDAP::MaterialDesignArtProvider unless Wx.const_defined?(:MaterialDesignArtProvider)

end
