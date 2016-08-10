# encoding: UTF-8

require 'spec_helper'

describe Abroad::Extractors::Yaml::DottedKeyExtractor do
  it 'preserves arrays as single values when asked' do
    content = YAML.dump(foo: { bar: %w(a b c) })
    extractor = Abroad::Extractors::Yaml::DottedKeyExtractor.from_string(content)
    enum = extractor.extract_each(preserve_arrays: true)

    phrases = enum.with_object({}) do |(key, value), ret|
      ret[key] = value
    end

    expect(phrases).to eq(
      'foo.bar' => %w(a b c)
    )
  end

  it "expands arrays if they don't contain only strings" do
    content = YAML.dump(foo: { bar: [{ baz: 'boo' }] })
    extractor = Abroad::Extractors::Yaml::DottedKeyExtractor.from_string(content)
    enum = extractor.extract_each(preserve_arrays: true)

    phrases = enum.with_object({}) do |(key, value), ret|
      ret[key] = value
    end

    expect(phrases).to eq(
      'foo.bar.0.baz' => 'boo'
    )
  end

  it 'handles nils' do
    content = YAML.dump(foo: nil)
    extractor = Abroad::Extractors::Yaml::DottedKeyExtractor.from_string(content)
    enum = extractor.extract_each

    phrases = enum.with_object({}) do |(key, value), ret|
      ret[key] = value
    end

    expect(phrases).to eq(
      'foo' => nil
    )
  end
end
