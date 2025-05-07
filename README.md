<img src="http://159.65.210.101/php-actions.png" align="right" alt="PHP Actions for Github" />

Run PHP Mess Detector tests in Github Actions.
==============================================

PHP Mess Detector (PHPMD) takes a given PHP source code base and looks for several potential problems within that source. These problems can be things like:

+ Possible bugs
+ Suboptimal code
+ Overcomplicated expressions
+ Unused parameters, methods, properties

Usage
-----

```yaml
name: CI

on: [push]

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Composer install
        uses: php-actions/composer@v6

      - name: PHP Mess Detector
        uses: php-actions/phpmd@v1
        with:
          php_version: 8.4
          path: src/
          output: text
          ruleset: test/phpmd/ruleset.xml
```

Version numbers
---------------

This action is released with semantic version numbers, but also tagged so the latest major release's tag always points to the latest release within the matching major version.

Please feel free to use `uses: php-actions/phpmd@v1` to always run the latest version of v1, or `uses: php-actions/phpmd@v1.0.0` to specify the exact release.

Inputs
------

The following configuration options are available:

+ `version` - What version of PHPMD to use e.g. `latest`, or `9`, or `9.5.0` (default: `composer` - use the version specified in composer.json)
+ `php_version` - What version of PHP to use e.g. `8.4` (default: latest)
+ `vendored_phpmd_path` - Path to a vendored phpmd binary
+ `path` - A php source code filename or directory. Can be a comma-separated string
+ `ruleset` - A ruleset filename or a comma-separated string of rulesetfilenames
+ `output` - A report format
+ `minimumpriority` - rule priority threshold; rules with lower priority than this will not be used
+ `reportfile` - send report output to a file; default to STDOUT
+ `suffixes` - comma-separated string of valid source code filename extensions, e.g. php,phtml
+ `exclude` - comma-separated string of patterns that are used to ignore directories. Use asterisks to exclude by pattern. For example *src/foo/*.php or *src/foo/*
+ `strict` - also report those nodes with a @SuppressWarnings annotation
+ `args` - Extra arguments to pass to the phpmd binary

If you require other configurations of PHPMD, please request them in the [Github issue tracker].

*****

If you found this repository helpful, please consider [sponsoring the developer][sponsor].

[Github issue tracker]: https://github.com/php-actions/phpmd/issues
[sponsor]: https://github.com/sponsors/g105b
