# GettextI18nRailsJs

[![Gem Version](http://img.shields.io/gem/v/gettext_i18n_rails_js.svg)](https://rubygems.org/gems/gettext_i18n_rails_js)
[![Build Status](https://secure.travis-ci.org/webhippie/gettext_i18n_rails_js.svg)](https://travis-ci.org/webhippie/gettext_i18n_rails_js)
[![Code Climate](https://codeclimate.com/github/webhippie/gettext_i18n_rails_js.svg)](https://codeclimate.com/github/webhippie/gettext_i18n_rails_js)
[![Test Coverage](https://codeclimate.com/github/webhippie/gettext_i18n_rails_js/badges/coverage.svg)](https://codeclimate.com/github/webhippie/gettext_i18n_rails_js)
[![Dependency Status](https://gemnasium.com/webhippie/gettext_i18n_rails_js.svg)](https://gemnasium.com/webhippie/gettext_i18n_rails_js)

Extends [gettext_i18n_rails](https://github.com/grosser/gettext_i18n_rails),
making your .PO files available to client side javascript as JSON. It will find
translations inside your .js, .coffee, .handlebars and .mustache files, then it
will create JSON versions of your .PO files so you can serve them with the rest
of your assets, thus letting you access all your translations offline from
client side javascript.


## Versions

This gem is tested on the following versions, it's also possible that it works
with older versions, but because of version bumps at `gettext_i18n_rails` and
`fast_gettext` we have dropped the older versions from the testing matrix:

* Ruby
  * 2.1.0
  * 2.2.0
* Rails
  * 3.2.21
  * 4.0.13
  * 4.1.16
  * 4.2.7


## Installation

```ruby
gem "gettext_i18n_rails_js", "~> 1.2.0"
```


## Usage

set up you rails application with gettext support as usual, afterwards just
execute the following rake task to export your translations to JSON:

```bash
rake gettext:po_to_json
```

Per default this will reconstruct the ```locale/<lang>/app.po``` structure as
javascript files inside ```app/assets/javascripts/locale/<lang>/app.js```

The gem provides the [Jed](https://github.com/SlexAxton/Jed) library to use the
generated javascript files. It also provides a global ```__``` function that
maps to `Jed#gettext`. The Jed instance used by the client side ```__```
function is pre-configured with the ```lang``` attribute specified in your main
HTML tag. Before anything, make sure your page's HTML tag includes a valid
```lang``` attribute, for example:

```haml
%html{ manifest: "", lang: I18n.locale }
```

Once you're sure your page is configured with a locale, then you should add
both your javascript locale files and the provided javascripts to your
application.js

```js
//= require_tree ./locale
//= require gettext/all
```

The default function name is ```window.__```, to avoid conflicts with
underscore.js. If you want to alias the function to something else in your
javascript you should also instruct the javascript and coffeescript parser to
look for a different function when finding your translations within the config
file ```config/gettext_i18n_rails_js.yml```, these are valid available options:

```yml
output_path: "app/assets/javascripts/locale"
handlebars_function: "__"
javascript_function: "__"
jed_options:
  pretty: false
```

If you prefer an initializer file within your rails application you can use
that in favor of the YML configuration as well:

```ruby
GettextI18nRailsJs.config do |config|
  config.output_path = "app/assets/javascripts/locale"

  config.handlebars_function = "__"
  config.javascript_function = "__"

  config.jed_options = {
    pretty: false
  }
end
```


## Todo

* More deep testing against multiple Rails versions
* Extend the current test suite, especially handlebars


## Contributing

Fork -> Patch -> Spec -> Push -> Pull Request


## Authors

* [Thomas Boerger](https://github.com/tboerger)
* [Nubis](https://github.com/nubis)
* [Other contributors](https://github.com/webhippie/gettext_i18n_rails_js/graphs/contributors)


## License

MIT


## Copyright

```
Copyright (c) 2012-2015 Dropmysite.com <https://dropmyemail.com>
Copyright (c) 2015 Webhippie <http://www.webhippie.de>
```
