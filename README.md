# Middleman-Livereload

middleman-livereload is an extension for the [Middleman] static site generator that adds livereloading functionality.

## Installation

If you're just getting started, install the `middleman` gem and generate a new project:

```
gem install middleman
middleman init MY_PROJECT
```

If you already have a Middleman project: Add `gem "middleman-livereload", "~> 3.1.0"` to your `Gemfile` and run `bundle install`

####Windows users: 
You currently need to add `gem "em-websocket", github: "igrigorik/em-websocket"` to your `Gemfile` and run `bundle install`
Also be sure to specify the correct hostname `activate :livereload, :host => 'localhost'`

## Configuration

```
activate :livereload
```

The extension supports a number of options that can be given to the `activate` statement. Eg:

```
activate :livereload, :apply_js_live => false, :grace_period => 0.5
```

#### `:api_version`

Livereload API version, default `'1.6'`.

#### `:host` and `:port`

Livereload's listener host/port, these options get passed to ::Rack::LiveReload  middleware. Defaults:`'0.0.0.0'` and `'35729'`.

#### `:apply_js_live` and `:apply_css_live`

Whether live reload should attempt to reload javascript / css 'in-place', without complete reload of the page. Both default to `true`.

#### `:grace_period`

A delay middleman-livereload should wait before reacting on file change / deletion notification (sec). Default is 0.

#### `:no_swf`

Disable Flash polyfil for browsers that support native WebSockets.

## Build & Dependency Status

[![Gem Version](https://badge.fury.io/rb/middleman-livereload.png)][gem]
[![Build Status](https://travis-ci.org/middleman/middleman-livereload.png)][travis]
[![Dependency Status](https://gemnasium.com/middleman/middleman-livereload.png?travis)][gemnasium]
[![Code Quality](https://codeclimate.com/github/middleman/middleman-livereload.png)][codeclimate]

## Community

The official community forum is available at: http://forum.middlemanapp.com

## Bug Reports

Github Issues are used for managing bug reports and feature requests. If you run into issues, please search the issues and submit new problems: https://github.com/middleman/middleman-livereload/issues

The best way to get quick responses to your issues and swift fixes to your bugs is to submit detailed bug reports, include test cases and respond to developer questions in a timely manner. Even better, if you know Ruby, you can submit [Pull Requests](https://help.github.com/articles/using-pull-requests) containing Cucumber Features which describe how your feature should work or exploit the bug you are submitting.

## How to Run Cucumber Tests

1. Checkout Repository: `git clone https://github.com/middleman/middleman-livereload.git`
2. Install Bundler: `gem install bundler`
3. Run `bundle install` inside the project root to install the gem dependencies.
4. Run test cases: `bundle exec rake test`

## Donate

[Click here to lend your support to Middleman](https://spacebox.io/s/4dXbHBorC3)

## License

Copyright (c) 2010-2013 Thomas Reynolds. MIT Licensed, see [LICENSE] for details.

[middleman]: http://middlemanapp.com
[gem]: https://rubygems.org/gems/middleman-livereload
[travis]: http://travis-ci.org/middleman/middleman-livereload
[gemnasium]: https://gemnasium.com/middleman/middleman-livereload
[codeclimate]: https://codeclimate.com/github/middleman/middleman-livereload
[LICENSE]: https://github.com/middleman/middleman-livereload/blob/master/LICENSE.md
