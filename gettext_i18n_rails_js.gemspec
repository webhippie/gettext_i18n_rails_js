# frozen_string_literal: true

#
# Copyright (c) 2012-2015 Dropmysite.com <https://dropmyemail.com>
# Copyright (c) 2015 Webhippie <http://www.webhippie.de>
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "gettext_i18n_rails_js/version"

Gem::Specification.new do |s|
  s.name = "gettext_i18n_rails_js"
  s.version = GettextI18nRailsJs::Version

  s.authors = ["Thomas Boerger", "Nubis"]
  s.email = ["thomas@webhippie.de", "nubis@woobiz.com.ar"]

  s.summary = <<-EOF
    Extends gettext_i18n_rails making your .po files available to client side
    javascript as JSON
  EOF

  s.description = <<-EOF
    It will find translations inside your .js and .coffee files, then it will
    create JSON versions of your .PO files and will let you serve them with the
    rest of your assets, thus letting you access all your translations offline
    from client side javascript.
  EOF

  s.homepage = "https://github.com/webhippie/gettext_i18n_rails_js"
  s.license = "MIT"

  s.files = ["CHANGELOG.md", "README.md", "LICENSE"]
  s.files += Dir.glob("lib/**/*")
  s.files += Dir.glob("vendor/**/*")

  s.test_files = Dir.glob("spec/**/*")

  s.executables = []
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 1.9.3"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "yard"

  s.add_dependency "gettext", ">= 3.0.2"
  s.add_dependency "gettext_i18n_rails", ">= 0.7.1"
  s.add_dependency "po_to_json", ">= 2.0.0"
  s.add_dependency "rails", ">= 3.2.0"
end
