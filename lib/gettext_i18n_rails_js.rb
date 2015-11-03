# -*- coding: UTF-8 -*-
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

gem "rails", version: ">= 3.2.0"
gem "gettext", version: ">= 3.0.2"
gem "gettext_i18n_rails", version: ">= 0.7.1"
gem "po_to_json", version: ">= 0.1.0"

require "rails"
require "gettext"
require "gettext_i18n_rails"
require "po_to_json"

require_relative "gettext_i18n_rails_js/version"
require_relative "gettext_i18n_rails_js/parser"
require_relative "gettext_i18n_rails_js/config"
require_relative "gettext_i18n_rails_js/engine"

module GettextI18nRailsJs
  class << self
    def config(&block)
      @config ||= GettextI18nRailsJs::Config.new(&block)
    end
  end
end
