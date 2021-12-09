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

require "gettext_i18n_rails/tasks"
require "gettext_i18n_rails_js/task"

namespace :gettext do
  desc "Convert PO files to JS files"
  task po_to_json: :environment do
    GettextI18nRailsJs::Task.po_to_json
  end

  # Required for gettext to filter the files
  def files_to_translate
    folders = [
      "app",
      "lib",
      "config",
      locale_path
    ].join(",")

    exts = [
      "rb",
      "erb",
      "haml",
      "slim",
      "rhtml",
      "js",
      "jsx",
      "vue",
      "coffee",
      "handlebars",
      "hbs",
      "mustache"
    ].join(",")

    Dir.glob(
      "{#{folders}}/**/*.{#{exts}}"
    )
  end
end
