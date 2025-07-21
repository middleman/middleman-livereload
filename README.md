# Middleman-Livereload

[![Gem Version](https://badge.fury.io/rb/middleman-livereload.svg)](https://rubygems.org/gems/middleman-livereload)
[![CI](https://github.com/middleman/middleman-livereload/actions/workflows/ci.yml/badge.svg)](https://github.com/middleman/middleman-livereload/actions/workflows/ci.yml)
[![Maintainability](https://qlty.sh/gh/middleman/projects/middleman-livereload/maintainability.svg)](https://qlty.sh/gh/middleman/projects/middleman-livereload)

`middleman-livereload` is an extension for the [Middleman](https://middlemanapp.com) static site generator that adds livereloading functionality.

## Installation

If you're just getting started, install the `middleman` gem and generate a new project:

```
gem install middleman
middleman init MY_PROJECT
```

If you already have a Middleman project, add the `gem "middleman-blog"` line to your `Gemfile` and then run `bundle install`.

## Configuration

```
activate :livereload
```

The extension supports a number of options that can be given to the `activate` statement. Eg:

```
activate :livereload, apply_js_live: false
```

- `:host` and `:port`

Livereload's listener host/port, these options get passed to ::Rack::LiveReload  middleware. Defaults:`'0.0.0.0'` and `'35729'`.

- `:js_host` and `:js_port`

Similar to the `:host` and `:port` options, but allow you to specify a different host and port at the frontend Javascript level than at the backend EventMachine level. Useful when running behind a proxy or on a Docker VM. Defaults to `:host` and `:port`.

- `:apply_js_live` and `:apply_css_live`

Whether live reload should attempt to reload javascript / css 'in-place', without complete reload of the page. Both default to `true`.

:warning: It does *not* work with `@import`'ed CSS files or `require`'d JS files (because of LiveReload not providing enough information regarding dependencies). On those kind of files, a full page reload will be triggered.

- `:no_swf`

Disable Flash polyfil for browsers that support native WebSockets.

- `:ignore`

Array of patterns for paths that must be ignored. These files will not be injected with the LiveReload script.

`String#match` is used for ignoring, so you can use any valid Ruby regular expression in this array.

- `:livereload_css_target`

CSS file to reload when detecting @imported partial was modified. Default `stylesheets/all.css`).  
To opt out set `livereload_css_target: nil`.

- `:livereload_css_pattern`

Regexp matching filenames that should trigger reload of :livereload_css_target when changed. Default: `Regexp.new('_.*\.css')`.

- `:wss_certificate` and `:wss_private_key`

Support secure sockets (WSS) by passing TLS certificate & private key, for
example if you're using `middleman server --https` in development.

## Community

The official community forum is available at: https://forum.middlemanapp.com

## Bug Reports

Github Issues are used for managing bug reports and feature requests. If you run into issues, please search the issues and submit new problems: https://github.com/middleman/middleman-livereload/issues

The best way to get quick responses to your issues and swift fixes to your bugs is to submit detailed bug reports, include test cases and respond to developer questions in a timely manner. Even better, if you know Ruby, you can submit [Pull Requests](https://help.github.com/articles/using-pull-requests) containing Cucumber Features which describe how your feature should work or exploit the bug you are submitting.

## Testing

`bundle exec rake test`

## Creating documentation

`bundle exec rake doc`

## Donate

[Click here to lend your support to Middleman](https://github.com/sponsors/tdreyno)

## License

Copyright (c) 2010-2017 Thomas Reynolds. MIT Licensed, see [LICENSE](LICENSE.md) for details.
