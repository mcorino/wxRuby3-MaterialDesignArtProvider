
require 'kramdown'
require 'kramdown-syntax-coderay'

module WxRuby3MDAP

  class KramdownDocument < Kramdown::Document

    def initialize(source, options = {})
      super(source, options.merge({syntax_highlighter: :coderay}))
    end

  end

end

YARD::Templates::Helpers::MarkupHelper::MARKUP_PROVIDERS[:markdown].each do |provider|
  if provider[:lib] == :kramdown
    provider[:const] = 'WxRuby3MDAP::KramdownDocument'
  end
end
