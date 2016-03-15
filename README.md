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

Abroad provides extractors for reading keys and values from localization files, and serializers for writing them out. The usage for each is slightly different.

### Extractors

Let's say you're working with this Rails YAML file:

```yaml
en:
  welcome_message: hello
  goodbye_message: goodbye
```

To extract strings from this file, try something like this:

```ruby
Abroad.extractor('yaml/rails').open('/path/to/en.yml') do |extractor|
  extractor.extract_each do |key, string|
    # on first iteration, key == 'welcome_message', string == 'hello'
    # on second iteration, key == 'goodbye_message', string == 'goodbye'
  end
end
```

The `Abroad.extractor` method returns a registered extractor class, or `nil` if the extractor can't be found. Extractor classes respond to `open`, `from_stream`, and `from_string`, and can either receive a block or not. If passed a block, the file or stream will be automatically closed when the block terminates. If you choose to not pass a block, you're responsible for calling `close` yourself.

Here's an example with all the steps broken down:

```ruby
extractor_klass = Abroad.extractor('yaml/rails')
extractor = extractor_klass.open('/path/to/yaml')
extractor.extract_each do |key, string|
  ...
end
extractor.close
```

The `extract_each` method on extractor instances returns an enumerable, which means you have access to all the wonderful `Enumerable` methods like `map`, `inject`, etc:

```ruby
Abroad.extractor('yaml/rails').open('/path/to/en.yml') do |extractor|
  extractor.extract_each.with_object({}) do |(key, string), result|
    result[key] = string
  end
end
```

To get a list of all available extractors, use the `extractors` method:

```ruby
Abroad.extractors  # => ["yaml/rails", "xml/android", ...]
```

## Requirements

This project has no external requirements.

## Running Tests

`bundle exec rake` or `bundle exec rspec` should do the trick.

## Authors

* Cameron C. Dutro: http://github.com/camertron
