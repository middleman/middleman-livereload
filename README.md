# middleman-livereload

middleman-livereload is an extension for the [Middleman](http://middlemanapp.com) static site generator that adds livereloading functionality.

# Install
If you're just getting started, install the `middleman` and `middleman-livereload` gems and generate a new project:

```
gem install middleman
gem install middleman-livereload
middleman init MY_PROJECT
```

If you already have a Middleman project:
Add `middleman-livereload` to your `Gemfile`
```
gem "middleman-livereload", "~>3.0.1"
```

Then open your `config.rb` and add:
```
activate :livereload
```

# Configuration

The extension supports a number of options that can be given to the `activate` statement. E.g.:
```
activate :livereload, :apply_js_live => false, :grace_period => 0.5
```

## :api_version

Livereload API version, default `'1.6'`.

## :host and :port

Livereload's listener host/port, these options get passed to ::Rack::LiveReload  middleware. Defaults:`'0.0.0.0'` and `'35729'`.

## :apply_js_live and :apply_css_live

Whether live reload should attempt to reload javascript / css 'in-place', without complete reload of the page. Both default to `true`.

## :grace_period

A delay middleman-livereload should wait before reacting on file change / deletion notification (sec). Default is 0.

# Community

The official community forum is available at:

  http://forum.middlemanapp.com/

# Bug Reports

GitHub Issues are used for managing bug reports and feature requests. If you run into issues, please search the issues and submit new problems:

https://github.com/middleman/middleman-livereload/issues

The best way to get quick responses to your issues and swift fixes to your bugs is to submit detailed bug reports, include test cases and respond to developer questions in a timely manner. Even better, if you know Ruby, you can submit Pull Requests containing Cucumber Features which describe how your feature should work or exploit the bug you are submitting.

# Donate

[![Click here to lend your support to Middleman](https://www.pledgie.com/campaigns/15807.png)](http://www.pledgie.com/campaigns/15807)
