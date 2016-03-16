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
  welcome:
    message: hello
  goodbye:
    message: goodbye
```

To extract strings from this file, try something like this:

```ruby
Abroad.extractor('yaml/rails').open('/path/to/en.yml') do |extractor|
  extractor.extract_each do |key, string|
    # on first iteration, key == 'welcome.message', string == 'hello'
    # on second iteration, key == 'goodbye.message', string == 'goodbye'
  end
end
```

The `Abroad.extractor` method returns a registered extractor class, or `nil` if the extractor can't be found. Extractor classes respond to `open`, `from_stream`, and `from_string`, and can be called with or without a block. If passed a block, the file or stream will be automatically closed when the block terminates. If you choose to not pass a block, you're responsible for calling `close` yourself.

Here's an example with all the steps broken down:

```ruby
extractor_klass = Abroad.extractor('yaml/rails')
extractor = extractor_klass.open('/path/to/en.yml')
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

### Serializers

While extractors pull strings out of localization files, serializers write them back in. Serializers conform to a similar interface, but offer different methods to write content out to the stream:

```ruby
Abroad.serializer('yaml/rails').open('/path/to/es.yml') do |serializer|
  serializer.write_key_value('welcome.message', 'hola')
  serializer.write_key_value('goodbye.message', 'adios')
end
```

In addition to `write_key_value`, serializer instances respond to the `write_raw` method, which is capable of writing raw text to the underlying stream. You might use this method if you needed to write a comment to the file or maybe a preamble at the beginning.

Serializer classes respond to `from_stream` in addition to `open`. Both methods can be called with or without a block. If passed a block, the file or stream will be automatically closed when the block terminates. If you choose to not pass a block, you're responsible for calling `close` yourself.

Here's an example with all the steps broken down:

```ruby
serializer_klass = Abroad.serializer('yaml/rails')
serializer = serializer_klass.open('/path/to/es.yml')
serializer.write_key_value('welcome.message', 'hola')
serializer.write_key_value('goodbye.message', 'adios')
serializer.close
```

To get a list of all available serializers, use the `serializers` method:

```ruby
Abroad.serializers  # => ["yaml/rails", "xml/android", ...]
```

### Writing Your Own

Conformant _extractors_ should inherit from `Abroad::Extractors::Extractor` and need to define the method `extract_each`. See lib/abroad/extractors/extractor.rb for a quick look at the interface. Methods that raise `NotImplementedError`s are ones you need to define in your subclass.

Conformant _serializers_ should inherit from `Abroad::Serializers::Serializer` and need to define the `write_key_value` and `write_raw` methods. See lib/abroad/serializers/serializer.rb for a quick look at the interface. Methods that raise `NotImplementedError`s are ones you need to define in your subclass.

Once you've finished writing your extractor or serializer, register it with Abroad:

```ruby
Abroad::Extractors.register('strings/ios', Strings::IosExtractor)
Abroad::Serializers.register('strings/ios', Strings::IosSerializer)
```

The first argument to the `register` method is called the serializer or extractor's _id_. The id can really be anything you want, but Abroad has established a convention of format/framework. The format is the underlying file format (eg. json, yaml, xml, etc), and the framework is the platform or application framework you're targeting (eg. iOS, Android, Rails, Django, etc). This makes it easy to avoid writing "one size fits all" classes. For example, it would be straightforward to add support for Chrome's localization file format, which is just json with a special structure. We might register an extractor with the id json/chrome instead of trying to retrofit our existing json extractor with Chrome-specific functionality.

## Requirements

This project has no external requirements.

## Running Tests

`bundle exec rake` or `bundle exec rspec` should do the trick.

## Authors

* Cameron C. Dutro: http://github.com/camertron
