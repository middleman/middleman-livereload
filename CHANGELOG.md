# Changelog

All notable changes to this project will be documented in this file.

## 3.5.0

* Upgade `rack-livereload` gem
* Migrate to GitHub Actions
* Match supported Ruby versions with MM ecosystem

## 3.4.7

* Support secure sockets (WSS) with options for TLS certificate & private key
* Fix crash when reloading `config.rb`
* Fix ignore files specificed in `:ignore` config

## 3.4.6

* Fix `Thread.exclusive` deprecation in older Rubies

## 3.4.5

* Fix pathname bug

## 3.4.4

* Add `:js_host` and `:js_port` options
* Fix CSS live reloading when @imported partials change

## 3.4.3

* Add `:ignore` option

## 3.4.2

* Safety check

## 3.4.1

* Tweak extension initialization

## 3.4.0

* Require new `middleman-core` gem

## 3.3.4

* Fall back to localhost if there's no private IP

## 3.3.3

* Upgrade `em-websocket` gem

## 3.3.2

* Add other authors in gemspec

## 3.3.1

* Default host is now autodetected

## 3.3.0

* Explicitly use the vendored livereload.js - otherwise it will attempt to load it from a location that doesn't exist
* Remove `:grace_period` setting, which was unnecessary
* Properly ignore changes to files that should not cause a reload, and pay attention to some files that used to be ignored but shouldn't have been
* Send logging to the logger rather than STDOUT
* No longer rely on MultiJson
* Require Ruby 1.9.3 or greater

## 3.2.1

* Loosen dependency on `middleman-core`

## 3.2.0

* Only run in `:development` environment
* No longer compatible with Middleman < 3.2

## 3.1.1

* Added `:no_swf` option to disable Flash websockets polyfill

## 3.1.0

* Compatibility with Middleman 3.1+ style extension API
* Ignore ignored sitemap files
* Preserve the reactor thread across preview server reloads
* Implement a `:grace_period` setting
