abroad
====================

A set of tools for serializing and extracting strings to and from a number of localization file formats. Currently supported formats are:

1. YAML, both plain and Rails-style
2. Android XML
3. JSON key/value

Adding additional extractors and serializers is straightforward; skip to the bottom of this document to learn more.

## Installation

`gem install abroad`, or add it to your Gemfile.

Then, somewhere in your project:

```ruby
require 'abroad'
```

## Introduction

Most application frameworks specify a way to localize (i.e. translate) UI phrases and other content. Usually this is done via flat, static files that map strings written in a source langage to translations written in any number of target languages. In Ruby on Rails, this is done via YAML files stored in the config/locales directory. Each file contains a series of nested key/value pairs, where the key is a machine-readable, globally unique identifier and the value is a human-readable bit of text meant to be displayed tp users of the web app. English strings go in config/locales/en.yml, Spanish strings go in config/locales/es.yml and so on. Both en.yml and es.yml contain the same set of keys, but different (translated) values for those keys.

Localization file formats are usually based on some standard format like YAML, but often extended in unique ways specific to the framework or platform. Interpreting these files can be difficult because of the various edge cases and platform-specific expectations. If you ever find yourself needing to parse or write out compatible files, consider using well-tested tools like the ones in this project.

## Usage

## Requirements

This project has no external requirements.

## Running Tests

`bundle exec rake` or `bundle exec rspec` should do the trick.

## Authors

* Cameron C. Dutro: http://github.com/camertron
