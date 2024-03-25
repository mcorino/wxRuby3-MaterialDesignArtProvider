# Copyright (c) 2023 M.J.N. Corino, The Netherlands
#
# This software is released under the MIT license.

require 'wx/core'

module Wx

  # Namespace for Material Design art provider elements.
  module MDArt

    class << self

      private

      def art_registry
        @art_registry ||= {}
      end

      def get_art(client_id, art_id)
        return nil unless art_registry.has_key?(client_id)
        art_registry[client_id][:art][art_id]
      end

      def art_client_groups
        @art_client_groups ||= {}
      end

      # @api private
      class ArtMapper
        def get_art(_client_id, _art_id)
          nil
        end

        class << self
          def null_mapper
            @null_mapper ||= ArtMapper.new
          end
        end
      end

      # @api private
      class StdArtMapper < ArtMapper

        def initialize
          @map = {}
        end

        def get_mapper(client_id)
          @map[client_id] || ArtMapper.null_mapper
        end

        def get_art(client_id, art_id)
          (@map[client_id] || ArtMapper.null_mapper).get_art(client_id, art_id)
        end

        def self.create(&block)
          std_mapper = StdArtMapper.new
          std_mapper.instance_eval(&block) if block_given?
          std_mapper
        end

        private

        def map_art(for_client: , &block)
          @map[for_client] = ArtClientIdMapMapper.create(self, &block)
        end

        def redirect_art(for_client:, to_client:, &block)
          @map[for_client] = ArtClientRedirectMapper.create(self, to_client, &block)
        end

      end

      # @api private
      class ArtClientIdMapMapper < ArtMapper
        def initialize(base)
          @base = base
          @id_map = ::Hash.new(ArtMapper.null_mapper) #.merge!(id_map)
        end

        def get_art(client_id, art_id)
          @id_map[art_id].get_art(client_id, art_id)
        end

        def self.create(base, &block)
          client_mapper = ArtClientIdMapMapper.new(base)
          client_mapper.instance_eval(&block) if block_given?
          client_mapper
        end

        protected

        def map_art_id(from_art:, to_art:, to_client: nil)
          @id_map[from_art] = ArtIdAlternateMapper.new(@base, to_art, to_client)
        end

      end

      # @api private
      class ArtIdAlternateMapper < ArtMapper
        def initialize(base, art_id, client_id=nil)
          @base = base
          @art_id = art_id
          @client_id = client_id
        end

        def get_art(client_id, _art_id)
          Wx::MDArt.__send__(:get_art, @client_id || client_id, @art_id)
        end
      end

      # @api private
      class ArtClientRedirectMapper < ArtClientIdMapMapper
        def initialize(base, tgt_client_id)
          super(base)
          @tgt_client_id = tgt_client_id
        end

        def get_art(client_id, art_id)
          super ||
            @base.get_mapper(@tgt_client_id).get_art(client_id, art_id) ||
            @base.get_mapper(@tgt_client_id).get_art(@tgt_client_id, art_id)
        end

        def self.create(base, tgt_client, &block)
          client_redirector = ArtClientRedirectMapper.new(base, tgt_client)
          client_redirector.instance_eval(&block) if block_given?
          client_redirector
        end

      end

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

      def std_client_alt(client_id = nil)
        @std_client_alt = client_id || @std_client_alt || Wx::MDArt::ART_FLUENT_UI_REGULAR
      end

      def std_mapper
        @std_mapper ||= StdArtMapper.create do
          map_art for_client: Wx::MDArt::ART_FLUENT_UI_FILLED do
            map_art_id from_art: Wx::ART_ERROR,  to_art: Wx::MDArt::ART_ERROR_CIRCLE
            map_art_id from_art: Wx::ART_QUESTION, to_art: Wx::MDArt::ART_QUESTION
            map_art_id from_art: Wx::ART_WARNING, to_art: Wx::MDArt::ART_WARNING
            map_art_id from_art: Wx::ART_INFORMATION, to_art: Wx::MDArt::ART_INFO
            map_art_id from_art: Wx::ART_ADD_BOOKMARK, to_art: Wx::MDArt::ART_BOOKMARK_ADD
            map_art_id from_art: Wx::ART_DEL_BOOKMARK, to_art: Wx::MDArt::ART_BOOKMARK_OFF
            map_art_id from_art: Wx::ART_HELP_SIDE_PANEL, to_art: Wx::MDArt::ART_PANEL_LEFT_TEXT
            map_art_id from_art: Wx::ART_HELP_SETTINGS, to_art: Wx::MDArt::ART_SETTINGS
            map_art_id from_art: Wx::ART_HELP_BOOK, to_art: Wx::MDArt::ART_BOOK
            map_art_id from_art: Wx::ART_HELP_FOLDER, to_art: Wx::MDArt::ART_BOOK_OPEN
            map_art_id from_art: Wx::ART_HELP_PAGE, to_art: Wx::MDArt::ART_DOCUMENT
            map_art_id from_art: Wx::ART_GO_BACK, to_art: Wx::MDArt::ART_ARROW_LEFT
            map_art_id from_art: Wx::ART_GO_FORWARD, to_art: Wx::MDArt::ART_ARROW_RIGHT
            map_art_id from_art: Wx::ART_GO_UP, to_art: Wx::MDArt::ART_ARROW_UP
            map_art_id from_art: Wx::ART_GO_DOWN, to_art: Wx::MDArt::ART_ARROW_DOWN
            map_art_id from_art: Wx::ART_GO_TO_PARENT, to_art: Wx::MDArt::ART_ARROW_TURN_UP_LEFT
            map_art_id from_art: Wx::ART_GO_HOME, to_art: Wx::MDArt::ART_HOME
            map_art_id from_art: Wx::ART_GOTO_FIRST, to_art: Wx::MDArt::ART_ARROW_PREVIOUS
            map_art_id from_art: Wx::ART_GOTO_LAST, to_art: Wx::MDArt::ART_ARROW_NEXT
            map_art_id from_art: Wx::ART_PRINT, to_art: Wx::MDArt::ART_PRINT
            map_art_id from_art: Wx::ART_HELP, to_art: Wx::MDArt::ART_QUESTION_CIRCLE
            map_art_id from_art: Wx::ART_TIP, to_art: Wx::MDArt::ART_LIGHTBULB
            map_art_id from_art: Wx::ART_REPORT_VIEW, to_art: Wx::MDArt::ART_CONTENT_VIEW
            map_art_id from_art: Wx::ART_LIST_VIEW, to_art: Wx::MDArt::ART_TEXT_BULLET_LIST_SQUARE
            map_art_id from_art: Wx::ART_NEW_DIR, to_art: Wx::MDArt::ART_FOLDER_ADD
            map_art_id from_art: Wx::ART_FOLDER, to_art: Wx::MDArt::ART_FOLDER
            map_art_id from_art: Wx::ART_FOLDER_OPEN, to_art: Wx::MDArt::ART_FOLDER_OPEN
            map_art_id from_art: Wx::ART_GO_DIR_UP, to_art: Wx::MDArt::ART_FOLDER_ARROW_UP
            map_art_id from_art: Wx::ART_EXECUTABLE_FILE, to_art: Wx::MDArt::ART_SETTINGS_COG_MULTIPLE
            map_art_id from_art: Wx::ART_NORMAL_FILE, to_art: Wx::MDArt::ART_DOCUMENT
            map_art_id from_art: Wx::ART_TICK_MARK, to_art: Wx::MDArt::ART_CHECKMARK
            map_art_id from_art: Wx::ART_CROSS_MARK, to_art: Wx::MDArt::ART_DISMISS
            map_art_id from_art: Wx::ART_MISSING_IMAGE, to_art: Wx::MDArt::ART_IMAGE_OFF
            map_art_id from_art: Wx::ART_NEW, to_art: Wx::MDArt::ART_DOCUMENT_ADD
            map_art_id from_art: Wx::ART_FILE_OPEN, to_art: Wx::MDArt::ART_DOCUMENT_FOLDER
            map_art_id from_art: Wx::ART_FILE_SAVE, to_art: Wx::MDArt::ART_SAVE
            map_art_id from_art: Wx::ART_FILE_SAVE_AS, to_art: Wx::MDArt::ART_SAVE_EDIT
            map_art_id from_art: Wx::ART_DELETE, to_art: Wx::MDArt::ART_DELETE
            map_art_id from_art: Wx::ART_COPY, to_art: Wx::MDArt::ART_COPY
            map_art_id from_art: Wx::ART_CUT, to_art: Wx::MDArt::ART_CUT
            map_art_id from_art: Wx::ART_PASTE, to_art: Wx::MDArt::ART_CLIPBOARD_PASTE
            map_art_id from_art: Wx::ART_UNDO, to_art: Wx::MDArt::ART_ARROW_UNDO
            map_art_id from_art: Wx::ART_REDO, to_art: Wx::MDArt::ART_ARROW_UNDO_TEMP_RTL
            map_art_id from_art: Wx::ART_PLUS, to_art: Wx::MDArt::ART_ADD
            map_art_id from_art: Wx::ART_MINUS, to_art: Wx::MDArt::ART_SUBTRACT
            map_art_id from_art: Wx::ART_CLOSE, to_art: Wx::MDArt::ART_DISMISS_CIRCLE
            map_art_id from_art: Wx::ART_QUIT, to_art: Wx::MDArt::ART_ARROW_EXIT
            map_art_id from_art: Wx::ART_FIND, to_art: Wx::MDArt::ART_SEARCH
            map_art_id from_art: Wx::ART_FIND_AND_REPLACE, to_art: Wx::MDArt::ART_FIND_REPLACE, to_client: Wx::MDArt::ART_MATERIAL_DESIGN_FILLED
            map_art_id from_art: Wx::ART_FULL_SCREEN, to_art: Wx::MDArt::ART_FULL_SCREEN_MAXIMIZE
            map_art_id from_art: Wx::ART_EDIT, to_art: Wx::MDArt::ART_EDIT
            map_art_id from_art: Wx::ART_HARDDISK, to_art: Wx::MDArt::ART_HARD_DRIVE
            map_art_id from_art: Wx::ART_FLOPPY, to_art: Wx::MDArt::ART_SAVE
            map_art_id from_art: Wx::ART_CDROM, to_art: Wx::MDArt::ART_CD
            map_art_id from_art: Wx::ART_REMOVABLE, to_art: Wx::MDArt::ART_PLUG_DISCONNECTED
            map_art_id from_art: Wx::ART_STOP, to_art: Wx::MDArt::ART_STOP
            map_art_id from_art: Wx::ART_REFRESH, to_art: Wx::MDArt::ART_ARROW_SYNC
          end

          redirect_art for_client: Wx::MDArt::ART_FLUENT_UI_REGULAR, to_client: Wx::MDArt::ART_FLUENT_UI_FILLED

          map_art for_client: Wx::MDArt::ART_MATERIAL_DESIGN_FILLED do
            map_art_id from_art: Wx::ART_ERROR, to_art: Wx::MDArt::ART_ERROR
            map_art_id from_art: Wx::ART_QUESTION, to_art: Wx::MDArt::ART_QUESTION_MARK
            map_art_id from_art: Wx::ART_WARNING, to_art: Wx::MDArt::ART_WARNING
            map_art_id from_art: Wx::ART_INFORMATION, to_art: Wx::MDArt::ART_INFO
            map_art_id from_art: Wx::ART_ADD_BOOKMARK, to_art: Wx::MDArt::ART_BOOKMARK_ADD
            map_art_id from_art: Wx::ART_DEL_BOOKMARK, to_art: Wx::MDArt::ART_BOOKMARK_REMOVE
            map_art_id from_art: Wx::ART_HELP_SIDE_PANEL, to_art: Wx::MDArt::ART_VERTICAL_SPLIT
            map_art_id from_art: Wx::ART_HELP_SETTINGS, to_art: Wx::MDArt::ART_SETTINGS
            map_art_id from_art: Wx::ART_HELP_BOOK, to_art: Wx::MDArt::ART_BOOK
            map_art_id from_art: Wx::ART_HELP_FOLDER, to_art: Wx::MDArt::ART_FOLDER
            map_art_id from_art: Wx::ART_HELP_PAGE, to_art: Wx::MDArt::ART_TEXT_SNIPPET
            map_art_id from_art: Wx::ART_GO_BACK, to_art: Wx::MDArt::ART_KEYBOARD_ARROW_LEFT
            map_art_id from_art: Wx::ART_GO_FORWARD, to_art: Wx::MDArt::ART_KEYBOARD_ARROW_RIGHT
            map_art_id from_art: Wx::ART_GO_UP, to_art: Wx::MDArt::ART_KEYBOARD_ARROW_UP
            map_art_id from_art: Wx::ART_GO_DOWN, to_art: Wx::MDArt::ART_KEYBOARD_ARROW_DOWN
            map_art_id from_art: Wx::ART_GO_TO_PARENT, to_art: Wx::MDArt::ART_REPLAY
            map_art_id from_art: Wx::ART_GO_HOME, to_art: Wx::MDArt::ART_HOME
            map_art_id from_art: Wx::ART_GOTO_FIRST, to_art: Wx::MDArt::ART_FIRST_PAGE
            map_art_id from_art: Wx::ART_GOTO_LAST, to_art: Wx::MDArt::ART_LAST_PAGE
            map_art_id from_art: Wx::ART_PRINT, to_art: Wx::MDArt::ART_PRINT
            map_art_id from_art: Wx::ART_HELP, to_art: Wx::MDArt::ART_HELP
            map_art_id from_art: Wx::ART_TIP, to_art: Wx::MDArt::ART_LIGHTBULB
            map_art_id from_art: Wx::ART_REPORT_VIEW, to_art: Wx::MDArt::ART_VIEW_COMFY_ALT
            map_art_id from_art: Wx::ART_LIST_VIEW, to_art: Wx::MDArt::ART_VIEW_LIST
            map_art_id from_art: Wx::ART_NEW_DIR, to_art: Wx::MDArt::ART_CREATE_NEW_FOLDER
            map_art_id from_art: Wx::ART_FOLDER, to_art: Wx::MDArt::ART_FOLDER
            map_art_id from_art: Wx::ART_FOLDER_OPEN, to_art: Wx::MDArt::ART_FOLDER_OPEN
            map_art_id from_art: Wx::ART_GO_DIR_UP, to_art: Wx::MDArt::ART_DRIVE_FOLDER_UPLOAD
            map_art_id from_art: Wx::ART_EXECUTABLE_FILE, to_art: Wx::MDArt::ART_MISCELLANEOUS_SERVICES
            map_art_id from_art: Wx::ART_NORMAL_FILE, to_art: Wx::MDArt::ART_INSERT_DRIVE_FILE
            map_art_id from_art: Wx::ART_TICK_MARK, to_art: Wx::MDArt::ART_CHECK
            map_art_id from_art: Wx::ART_CROSS_MARK, to_art: Wx::MDArt::ART_CLEAR
            map_art_id from_art: Wx::ART_MISSING_IMAGE, to_art: Wx::MDArt::ART_IMAGE_NOT_SUPPORTED
            map_art_id from_art: Wx::ART_NEW, to_art: Wx::MDArt::ART_NOTE_ADD
            map_art_id from_art: Wx::ART_FILE_OPEN, to_art: Wx::MDArt::ART_FILE_OPEN
            map_art_id from_art: Wx::ART_FILE_SAVE, to_art: Wx::MDArt::ART_SAVE
            map_art_id from_art: Wx::ART_FILE_SAVE_AS, to_art: Wx::MDArt::ART_SAVE_AS
            map_art_id from_art: Wx::ART_DELETE, to_art: Wx::MDArt::ART_DELETE
            map_art_id from_art: Wx::ART_COPY, to_art: Wx::MDArt::ART_CONTENT_COPY
            map_art_id from_art: Wx::ART_CUT, to_art: Wx::MDArt::ART_CONTENT_CUT
            map_art_id from_art: Wx::ART_PASTE, to_art: Wx::MDArt::ART_CONTENT_PASTE
            map_art_id from_art: Wx::ART_UNDO, to_art: Wx::MDArt::ART_UNDO
            map_art_id from_art: Wx::ART_REDO, to_art: Wx::MDArt::ART_REDO
            map_art_id from_art: Wx::ART_PLUS, to_art: Wx::MDArt::ART_ADD
            map_art_id from_art: Wx::ART_MINUS, to_art: Wx::MDArt::ART_REMOVE
            map_art_id from_art: Wx::ART_CLOSE, to_art: Wx::MDArt::ART_CANCEL
            map_art_id from_art: Wx::ART_QUIT, to_art: Wx::MDArt::ART_EXIT_TO_APP
            map_art_id from_art: Wx::ART_FIND, to_art: Wx::MDArt::ART_SEARCH
            map_art_id from_art: Wx::ART_FIND_AND_REPLACE, to_art: Wx::MDArt::ART_FIND_REPLACE
            map_art_id from_art: Wx::ART_FULL_SCREEN, to_art: Wx::MDArt::ART_FULLSCREEN
            map_art_id from_art: Wx::ART_EDIT, to_art: Wx::MDArt::ART_EDIT
            map_art_id from_art: Wx::ART_HARDDISK, to_art: Wx::MDArt::ART_HARD_DRIVE, to_client: Wx::MDArt::ART_FLUENT_UI_FILLED
            map_art_id from_art: Wx::ART_FLOPPY, to_art: Wx::MDArt::ART_SAVE
            map_art_id from_art: Wx::ART_CDROM, to_art: Wx::MDArt::ART_CD, to_client: Wx::MDArt::ART_FLUENT_UI_FILLED
            map_art_id from_art: Wx::ART_REMOVABLE, to_art: Wx::MDArt::ART_PLUG_DISCONNECTED, to_client: Wx::MDArt::ART_FLUENT_UI_FILLED
            map_art_id from_art: Wx::ART_STOP, to_art: Wx::MDArt::ART_STOP
            map_art_id from_art: Wx::ART_REFRESH, to_art: Wx::MDArt::ART_SYNC
          end

          redirect_art for_client: Wx::MDArt::ART_MATERIAL_DESIGN_OUTLINED, to_client: Wx::MDArt::ART_MATERIAL_DESIGN_FILLED do
            map_art_id from_art: Wx::ART_HARDDISK, to_art: Wx::MDArt::ART_HARD_DRIVE, to_client: Wx::MDArt::ART_FLUENT_UI_REGULAR
            map_art_id from_art: Wx::ART_REMOVABLE, to_art: Wx::MDArt::ART_PLUG_DISCONNECTED, to_client: Wx::MDArt::ART_FLUENT_UI_REGULAR
          end

          redirect_art for_client: Wx::MDArt::ART_MATERIAL_DESIGN_ROUND, to_client: Wx::MDArt::ART_MATERIAL_DESIGN_FILLED

          redirect_art for_client: Wx::MDArt::ART_MATERIAL_DESIGN_SHARP, to_client: Wx::MDArt::ART_MATERIAL_DESIGN_FILLED

          redirect_art for_client: Wx::MDArt::ART_MATERIAL_DESIGN_TWO_TONE, to_client: Wx::MDArt::ART_MATERIAL_DESIGN_FILLED do
            map_art_id from_art: Wx::ART_HARDDISK, to_art: Wx::MDArt::ART_HARD_DRIVE, to_client: Wx::MDArt::ART_FLUENT_UI_REGULAR
            map_art_id from_art: Wx::ART_REMOVABLE, to_art: Wx::MDArt::ART_PLUG_DISCONNECTED, to_client: Wx::MDArt::ART_FLUENT_UI_REGULAR
          end

          map_art for_client: Wx::MDArt::ART_FONT_AWESOME_SOLID do
            map_art_id from_art: Wx::ART_ERROR, to_art: Wx::MDArt::ART_CIRCLE_EXCLAMATION
            map_art_id from_art: Wx::ART_QUESTION, to_art: Wx::MDArt::ART_QUESTION
            map_art_id from_art: Wx::ART_WARNING, to_art: Wx::MDArt::ART_TRIANGLE_EXCLAMATION
            map_art_id from_art: Wx::ART_INFORMATION, to_art: Wx::MDArt::ART_CIRCLE_INFO
            map_art_id from_art: Wx::ART_ADD_BOOKMARK, to_art: Wx::MDArt::ART_BOOKMARK_ADD, to_client: Wx::MDArt::ART_FLUENT_UI_FILLED
            map_art_id from_art: Wx::ART_DEL_BOOKMARK, to_art: Wx::MDArt::ART_BOOKMARK_OFF, to_client: Wx::MDArt::ART_FLUENT_UI_FILLED
            map_art_id from_art: Wx::ART_HELP_SIDE_PANEL, to_art: Wx::MDArt::ART_PANEL_LEFT_TEXT, to_client: Wx::MDArt::ART_FLUENT_UI_FILLED
            map_art_id from_art: Wx::ART_HELP_SETTINGS, to_art: Wx::MDArt::ART_SETTINGS, to_client: Wx::MDArt::ART_FLUENT_UI_FILLED
            map_art_id from_art: Wx::ART_HELP_BOOK, to_art: Wx::MDArt::ART_BOOK
            map_art_id from_art: Wx::ART_HELP_FOLDER, to_art: Wx::MDArt::ART_FOLDER
            map_art_id from_art: Wx::ART_HELP_PAGE, to_art: Wx::MDArt::ART_FILE_LINES
            map_art_id from_art: Wx::ART_GO_BACK, to_art: Wx::MDArt::ART_ANGLE_LEFT
            map_art_id from_art: Wx::ART_GO_FORWARD, to_art: Wx::MDArt::ART_ANGLE_RIGHT
            map_art_id from_art: Wx::ART_GO_UP, to_art: Wx::MDArt::ART_ANGLE_UP
            map_art_id from_art: Wx::ART_GO_DOWN, to_art: Wx::MDArt::ART_ANGLE_DOWN
            map_art_id from_art: Wx::ART_GO_TO_PARENT, to_art: Wx::MDArt::ART_ARROW_TURN_UP
            map_art_id from_art: Wx::ART_GO_HOME, to_art: Wx::MDArt::ART_HOUSE
            map_art_id from_art: Wx::ART_GOTO_FIRST, to_art: Wx::MDArt::ART_ANGLES_LEFT
            map_art_id from_art: Wx::ART_GOTO_LAST, to_art: Wx::MDArt::ART_ANGLES_RIGHT
            map_art_id from_art: Wx::ART_PRINT, to_art: Wx::MDArt::ART_PRINT
            map_art_id from_art: Wx::ART_HELP, to_art: Wx::MDArt::ART_CIRCLE_QUESTION
            map_art_id from_art: Wx::ART_TIP, to_art: Wx::MDArt::ART_LIGHTBULB
            map_art_id from_art: Wx::ART_REPORT_VIEW, to_art: Wx::MDArt::ART_TABLE_COLUMNS
            map_art_id from_art: Wx::ART_LIST_VIEW, to_art: Wx::MDArt::ART_TABLE_LIST
            map_art_id from_art: Wx::ART_NEW_DIR, to_art: Wx::MDArt::ART_FOLDER_PLUS
            map_art_id from_art: Wx::ART_FOLDER, to_art: Wx::MDArt::ART_FOLDER
            map_art_id from_art: Wx::ART_FOLDER_OPEN, to_art: Wx::MDArt::ART_FOLDER_OPEN
            map_art_id from_art: Wx::ART_GO_DIR_UP, to_art: Wx::MDArt::ART_ARROW_TURN_UP
            map_art_id from_art: Wx::ART_EXECUTABLE_FILE, to_art: Wx::MDArt::ART_GEARS
            map_art_id from_art: Wx::ART_NORMAL_FILE, to_art: Wx::MDArt::ART_FILE
            map_art_id from_art: Wx::ART_TICK_MARK, to_art: Wx::MDArt::ART_CHECK
            map_art_id from_art: Wx::ART_CROSS_MARK, to_art: Wx::MDArt::ART_XMARK
            map_art_id from_art: Wx::ART_MISSING_IMAGE, to_art: Wx::MDArt::ART_RECTANGLE_XMARK
            map_art_id from_art: Wx::ART_NEW, to_art: Wx::MDArt::ART_FILE_CIRCLE_PLUS
            map_art_id from_art: Wx::ART_FILE_OPEN, to_art: Wx::MDArt::ART_FILE_ARROW_UP
            map_art_id from_art: Wx::ART_FILE_SAVE, to_art: Wx::MDArt::ART_FILE_ARROW_DOWN
            map_art_id from_art: Wx::ART_FILE_SAVE_AS, to_art: Wx::MDArt::ART_FILE_PEN
            map_art_id from_art: Wx::ART_DELETE, to_art: Wx::MDArt::ART_TRASH_CAN
            map_art_id from_art: Wx::ART_COPY, to_art: Wx::MDArt::ART_COPY
            map_art_id from_art: Wx::ART_CUT, to_art: Wx::MDArt::ART_SCISSORS
            map_art_id from_art: Wx::ART_PASTE, to_art: Wx::MDArt::ART_PASTE
            map_art_id from_art: Wx::ART_UNDO, to_art: Wx::MDArt::ART_ARROW_ROTATE_LEFT
            map_art_id from_art: Wx::ART_REDO, to_art: Wx::MDArt::ART_ARROW_ROTATE_RIGHT
            map_art_id from_art: Wx::ART_PLUS, to_art: Wx::MDArt::ART_PLUS
            map_art_id from_art: Wx::ART_MINUS, to_art: Wx::MDArt::ART_MINUS
            map_art_id from_art: Wx::ART_CLOSE, to_art: Wx::MDArt::ART_CIRCLE_XMARK
            map_art_id from_art: Wx::ART_QUIT, to_art: Wx::MDArt::ART_ARROW_RIGHT_FROM_BRACKET
            map_art_id from_art: Wx::ART_FIND, to_art: Wx::MDArt::ART_MAGNIFYING_GLASS
            map_art_id from_art: Wx::ART_FIND_AND_REPLACE, to_art: Wx::MDArt::ART_FIND_REPLACE, to_client: Wx::MDArt::ART_MATERIAL_DESIGN_FILLED
            map_art_id from_art: Wx::ART_FULL_SCREEN, to_art: Wx::MDArt::ART_EXPAND
            map_art_id from_art: Wx::ART_EDIT, to_art: Wx::MDArt::ART_PEN
            map_art_id from_art: Wx::ART_HARDDISK, to_art: Wx::MDArt::ART_HARD_DRIVE
            map_art_id from_art: Wx::ART_FLOPPY, to_art: Wx::MDArt::ART_FLOPPY_DISK
            map_art_id from_art: Wx::ART_CDROM, to_art: Wx::MDArt::ART_CD, to_client: Wx::MDArt::ART_FLUENT_UI_FILLED
            map_art_id from_art: Wx::ART_REMOVABLE, to_art: Wx::MDArt::ART_PLUG
            map_art_id from_art: Wx::ART_STOP, to_art: Wx::MDArt::ART_STOP
            map_art_id from_art: Wx::ART_REFRESH, to_art: Wx::MDArt::ART_ARROWS_ROTATE
          end

          redirect_art for_client: Wx::MDArt::ART_FONT_AWESOME_REGULAR, to_client: Wx::MDArt::ART_FONT_AWESOME_SOLID do
            map_art_id from_art: Wx::ART_ADD_BOOKMARK, to_art: Wx::MDArt::ART_BOOKMARK_ADD, to_client: Wx::MDArt::ART_FLUENT_UI_REGULAR
            map_art_id from_art: Wx::ART_DEL_BOOKMARK, to_art: Wx::MDArt::ART_BOOKMARK_REMOVE, to_client: Wx::MDArt::ART_FLUENT_UI_REGULAR
            map_art_id from_art: Wx::ART_HELP_SIDE_PANEL, to_art: Wx::MDArt::ART_PANEL_LEFT_TEXT, to_client: Wx::MDArt::ART_FLUENT_UI_REGULAR
            map_art_id from_art: Wx::ART_HELP_SETTINGS, to_art: Wx::MDArt::ART_SETTINGS, to_client: Wx::MDArt::ART_FLUENT_UI_REGULAR
            map_art_id from_art: Wx::ART_FIND_AND_REPLACE, to_art: Wx::MDArt::ART_FIND_REPLACE, to_client: Wx::MDArt::ART_MATERIAL_DESIGN_OUTLINED
            map_art_id from_art: Wx::ART_CDROM, to_art: Wx::MDArt::ART_CD, to_client: Wx::MDArt::ART_FLUENT_UI_REGULAR
          end
        end
      end

      # Collects art from the given collection and auto-creates art client ids and art ids.
      # Registers all art for later retrieval.
      # @param [String] collection name of art collection (folder)
      # @return [void]
      def collect_art_for(collection)
        # recursively iterate the folders and files of the `collection` directory
        # and auto-create Art Client Ids and Art Ids
        art_folder = File.directory?(collection) ? File.expand_path(collection) : File.join(__dir__, 'art', collection)
        art_group = File.basename(art_folder, '.*').upcase.gsub('-', '_')
        raise ArgumentError, "Cannot find art folder #{collection}." unless File.directory?(art_folder)
        art_client_groups[art_group] ||= []
        Dir[File.join(art_folder, '*')].each do |art_client_path|
          if File.directory?(art_client_path)
            # does this folder contain SVG files?
            img_list = Dir[File.join(art_client_path, '*.svg')]
            unless img_list.empty?

              # create ArtClientId constant for this folder and register art client
              art_const = "ART_#{art_group}_#{File.basename(art_client_path, '.*').upcase.gsub('-', '_')}"
              art_client_id = const_set(art_const, "#{art_const}_C")
              art_registry[art_client_id] = { const: art_const.to_sym, art: {} }
              art_client_groups[art_group] << art_const.to_sym

              # create and register ArtId for each image file
              art_id_registry = art_registry[art_client_id][:art]
              img_list.each do |img_file|
                art_id = "ART_#{File.basename(img_file, '.*').upcase.gsub('-', '_')}"
                const_set(art_id, art_id) unless const_defined?(art_id)
                art_id_registry[art_id] = img_file
              end

            end
          end
        end
        nil
      end
      private :collect_art_for

      public

      # Sets the MDArt client id to use when a std wxWidgets ClientArtId is passed to {MaterialDesignArtProvider}.
      # By default the alternative id used is {Wx::MDArt::ART_FLUENT_UI_REGULAR}.
      # The `client_id` passed should be one of:
      #
      # - {Wx::MDArt::ART_FLUENT_UI_REGULAR}
      # - {Wx::MDArt::ART_FLUENT_UI_FILLED}
      # - {Wx::MDArt::ART_FONT_AWESOME_REGULAR}
      # - {Wx::MDArt::ART_FONT_AWESOME_SOLID}
      # - {Wx::MDArt::ART_MATERIAL_DESIGN_FILLED}
      # - {Wx::MDArt::ART_MATERIAL_DESIGN_OUTLINED}
      # - {Wx::MDArt::ART_MATERIAL_DESIGN_ROUND}
      # - {Wx::MDArt::ART_MATERIAL_DESIGN_SHARP}
      # - {Wx::MDArt::ART_MATERIAL_DESIGN_TWO_TONE}
      #
      # @param [String] client_id the alternative client id to use
      def set_std_client_alternative(client_id)
        std_client_alt(client_id)
      end
      alias :std_client_alternative= :set_std_client_alternative

      # @api private
      def get_art_client_group_ids
        art_client_groups.keys
      end
      alias :art_client_group_ids :get_art_client_group_ids

      # @api private
      def get_art_client_ids_for_group(grp_id)
        art_client_groups[grp_id] || []
      end
      alias :art_client_ids_for_group :get_art_client_ids_for_group

      # @api private
      def get_art_group_for_client(client)
        grp, _ = art_client_groups.find { |_, grp_clients| grp_clients.include?(client) }
        grp
      end
      alias :art_group_for_client :get_art_group_for_client

      # @api private
      def get_art_ids_for_group(grp_id)
        get_art_client_ids_for_group(grp_id).inject([]) { |list, sym| list |= get_all_art_ids_for(MDArt.const_get(sym)) }.sort
      end
      alias :art_ids_for_group :get_art_ids_for_group

      # Returns the image path for the art for the specified client and id
      # @param [String] client art client id
      # @param [String] id art id
      # @return [String] art path
      def get_art_for(client, id)
        # if the client id is a std wxWidgets client id map to ART_FLUENT_UI_FILLED
        if std_client_ids.include?(client)
          client = std_client_alt
        end
        # try to resolve exact match
        art_path = get_art(client, id)
        # if not found and this is a standard wxWidgets Art Id try the std mappers
        if art_path.nil? && id.start_with?('wx')
          art_path = std_mapper.get_art(client, id)
        end
        art_path
      end
      alias :art_for :get_art_for

      # Returns a list op all art client constant names (as symbols).
      # @return [Array<Symbol>] art client constant names
      def get_all_art_clients
        art_registry.values.collect { |clreg| clreg[:const] }
      end
      alias :all_art_clients :get_all_art_clients

      # Returns a list of all art id constant names (as symbols) for the given art client id
      # @param [String] client Art Client Id
      # @return [Array<Symbol>] art id constant names
      def get_all_art_ids_for(client)
        art_registry.has_key?(client) ? art_registry[client][:art].keys.collect { |art_id| art_id.to_sym } : []
      end
      alias :all_art_ids_for :get_all_art_ids_for

      # @api private
      def has_art_id?(client, id)
        art_registry.has_key?(client) && art_registry[client][:art].has_key?(id)
      end

      # Returns a list of all Material Design art id constant names (as symbols)
      # @return [Array<Symbol>] art id constant names
      def get_all_art_ids
        art_registry.values.collect { |clreg| clreg[:art].keys.collect { |art_id| art_id.to_sym } }.flatten.uniq
      end
      alias :all_art_ids :get_all_art_ids

    end

    collect_art_for('fluent_ui')
    collect_art_for('font_awesome')
    collect_art_for('material_design')
    collect_art_for('simple_icons')

    # Material Design art provider class.
    class MaterialDesignArtProvider < Wx::ArtProvider

      protected

      def create_bitmap(id, client, size)
        # create bundle and get bitmap from it
        bundle = create_bitmap_bundle(id, client, size)
        return Wx::NULL_BITMAP unless bundle.ok?
        bmp = bundle.get_bitmap(size)
        bmp.ok? ? bmp : Wx::NULL_BITMAP
      end

      def create_bitmap_bundle(id, client, size)
        art_path = MDArt.get_art_for(client, id)
        return Wx::NULL_BITMAP unless art_path
        size = size.to_size # make sure to have a Wx::Size
        size = Wx::Size.new(24,24) if size == Wx::DEFAULT_SIZE
        # create bundle
        Wx::BitmapBundle.from_svg_file(art_path, size)
      end

      def create_icon_bundle(id, client)
        bundle = create_bitmap_bundle(id, client, [24,24])
        Wx::IconBundle.new(bundle.get_icon([24,24]))
      end


    end

  end

end
