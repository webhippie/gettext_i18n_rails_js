# gettext_i18n_rails_js

[![Test Status](https://github.com/webhippie/gettext_i18n_rails_js/actions/workflows/testing.yml/badge.svg)](https://github.com/webhippie/gettext_i18n_rails_js/actions/workflows/testing.yaml) [![Join the Matrix chat at https://matrix.to/#/#webhippie:matrix.org](https://img.shields.io/badge/matrix-%23webhippie%3Amatrix.org-7bc9a4.svg)](https://matrix.to/#/#webhippie:matrix.org) [![Codacy Badge](https://app.codacy.com/project/badge/Grade/51f241a0f0d7490cae0bdc04387f9d13)](https://app.codacy.com/gh/webhippie/gettext_i18n_rails_js/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade) [![Gem Version](https://badge.fury.io/rb/gettext_i18n_rails_js.svg)](https://badge.fury.io/rb/gettext_i18n_rails_js)

Extends [gettext_i18n_rails](https://github.com/grosser/gettext_i18n_rails),
making your .PO files available to client side javascript as JSON. It will find
translations inside your .js, .coffee, .handlebars and .mustache files, then it
will create JSON versions of your .PO files so you can serve them with the rest
of your assets, thus letting you access all your translations offline from
client side javascript.

## Versions

For a list of the tested and supported Ruby and Rails versions please take a
look at the [wokflow][workflow].

## Installation

```ruby
gem 'gettext_i18n_rails_js', '~> 2.0'
```

## Versioning

This library aims to adhere to [Semantic Versioning 2.0.0][semver]. Violations
of this scheme should be reported as bugs. Specifically, if a minor or patch
version is released that breaks backward compatibility, a new version should be
immediately released that restores compatibility. Breaking changes to the public
API will only be introduced with new major versions.

As a result of this policy, you can (and should) specify a dependency on this
gem using the [Pessimistic Version Constraint][pvc] with two digits of precision.

For example:

```ruby
spec.add_dependency 'gettext_i18n_rails_js', '~> 2.0'
```

## Usage

Set up you rails application with gettext support as usual, afterwards just
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

## Contributing

Fork -> Patch -> Spec -> Push -> Pull Request

## Authors

*   [Thomas Boerger](https://github.com/tboerger)
*   [Nubis](https://github.com/nubis)
*   [Other contributors](https://github.com/webhippie/gettext_i18n_rails_js/graphs/contributors)

## License

MIT

## Copyright

```
Copyright (c) 2012-2015 Dropmysite.com <https://dropmyemail.com>
Copyright (c) 2015 Webhippie <http://www.webhippie.de>
```

[workflow]: https://github.com/webhippie/gettext_i18n_rails_js/blob/master/.github/workflows/testing.yml
[semver]: http://semver.org
[pvc]: http://guides.rubygems.org/patterns/#pessimistic-version-constraint
