require 'rubygems'

$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))

require 'tempfile'
require 'rails'
require 'gettext_i18n_rails_js'

def with_file(content)
  Tempfile.open('gettext_i18n_rails_specs') do |f|
    f.write(content)
    f.close
    yield f.path
  end
end

