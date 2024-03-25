# frozen_string_literal: true

def init
  # It seems YARD messes things up so that a lot of classes, modules and constants are not properly
  # registered in their enclosing namespaces.
  # This hack makes sure that if that is the case we fix that here.
  all_objects = Registry.all(:class, :constant, :module, :method)
  all_objects.each do |c|
    if (ns = c.namespace)
      unless ns.children.any? { |nsc| nsc.path == c.path }
        ns.children << c # class/module/constant/method missing from child list of enclosing namespace -> add here
      end
    end
    if (ns = Registry[c.namespace.path])
      unless ns.children.any? { |nsc| nsc.path == c.path }
        ns.children << c # class/module/constant/method missing from child list of enclosing namespace -> add here
      end
    end
  end
  super
end

def stylesheets_full_list
  super + %w(css/wxruby3.css)
end

def logo_and_version
  wxver = Registry['Wx::MDArt::VERSION']
  <<~__HTML
  <div class='wxrb-logo'>
    <img src='art/logo.svg' height='38'/>
    <table><tbody>
      <tr><td><span class='wxrb-name'><a href="https://github.com/mcorino/wxRuby3-MaterialDesignArtProvider">wxRuby3 MaterialDesignArtProvider</a></span></td></tr>
      <tr><td><span class='wxrb-version'>Version: #{::Kernel.eval(wxver.value)}</span></td></tr>
    </tbody></table>
  </div>
  __HTML
end
