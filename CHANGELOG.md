# Changelog

## [2.2.1](https://github.com/webhippie/gettext_i18n_rails_js/compare/v2.2.0...v2.2.1) (2025-09-22)


### Bugfixes

* **patch:** update dependency ruby to v3.4.6 ([#94](https://github.com/webhippie/gettext_i18n_rails_js/issues/94)) ([0d92393](https://github.com/webhippie/gettext_i18n_rails_js/commit/0d923931d22bf42b66f9f01e64413f39d019fd41))

## [2.2.0](https://github.com/webhippie/gettext_i18n_rails_js/compare/v2.1.0...v2.2.0) (2025-09-12)


### Features

* integrate automated release process ([d5d5c31](https://github.com/webhippie/gettext_i18n_rails_js/commit/d5d5c310c154ffa543969368fe264dda1c7060b6))
* update rubocop rules and test cases ([abf02a4](https://github.com/webhippie/gettext_i18n_rails_js/commit/abf02a425967e60008a8f2678bd5b81f71aaa503))


### Bugfixes

* always download via https from rubygems ([f760826](https://github.com/webhippie/gettext_i18n_rails_js/commit/f760826352b73e768b9ed29c7b8fba7b38bf8af6))
* respect new version variable ([0801533](https://github.com/webhippie/gettext_i18n_rails_js/commit/0801533db52d9eebe697b5ce29878bcc264f245e))

## [2.1.0](https://github.com/webhippie/gettext_i18n_rails_js/releases/tag/v2.1.0) - 2024-05-23

*   Autoload parsers only on first usage to reduce memory consumption (@jrafanie)

## [2.0.0](https://github.com/webhippie/gettext_i18n_rails_js/releases/tag/v2.0.0) - 2023-07-20

*   Upgrade to latest po_to_json which fixes double quotes within msgid (@tboerger)

## [1.4.0](https://github.com/webhippie/gettext_i18n_rails_js/releases/tag/v1.4.0) - 2023-05-01

*   Added support for doing conversion for different domains and rails engines (@adamruzicka)

## [1.3.1](https://github.com/webhippie/gettext_i18n_rails_js/releases/tag/v1.3.1) - 2021-12-08

*   Fixed multiline translation strings (@delxen)
*   Switched to Codacy for coverage reports (@tboerger)
*   Switched to GitHub actions for CI (@ezr-ondrej)

## [1.3.0](https://github.com/webhippie/gettext_i18n_rails_js/releases/tag/v1.3.0) - 2017-03-16

*   Fixed Handlebars translations with options (@mikezaby)
*   Fixed latest Rubocop offenses (@mikezaby)
*   Dropped failing coveralls, fixed codeclimate (@tboerger)

## [1.2.0](https://github.com/webhippie/gettext_i18n_rails_js/releases/tag/v1.2.0) - 2016-06-02

*   Support for JSX files (@artemv)
*   Fixed test suite, reduced test matrix (@tboerger)

## [1.1.0](https://github.com/webhippie/gettext_i18n_rails_js/releases/tag/v1.1.0) - 2016-06-02

*   Replace hyphens with underscores in locale var from DOM (@filib)

## [1.0.4](https://github.com/webhippie/gettext_i18n_rails_js/releases/tag/v1.0.4) - 2016-05-31

*   Support ES2015 template strings (@bradbarrow)

## [1.0.3](https://github.com/webhippie/gettext_i18n_rails_js/releases/tag/v1.0.3) - 2015-11-03

*   Stop using bundler within the core lib (@domcleal)

## [1.0.2](https://github.com/webhippie/gettext_i18n_rails_js/releases/tag/v1.0.2) - 2015-03-30

*   Fixes exception when parsing empty js/coffee files (@tboerger)
*   Avoid methods defined in rake task exposing globally (@tboerger)
*   Added better configuration options (@tboerger)

## [1.0.1](https://github.com/webhippie/gettext_i18n_rails_js/releases/tag/v1.0.1) - 2015-02-24

*   Added missing javascripts to the gemspec (@tboerger)

## [1.0.0](https://github.com/webhippie/gettext_i18n_rails_js/releases/tag/v1.0.0) - 2015-02-24

*   Transfer from github.com/nubis/gettext_i18n_rails_js (@tboerger)
*   Added TravisCI, Rubocop and Coveralls (@tboerger)
*   Updated structure to my opinionated gem style (@tboerger)
*   Changed default handlebars function to ```__``` (@tboerger)
*   Added extended ```gettext_i18n_rails_js.yml``` (@tboerger)
