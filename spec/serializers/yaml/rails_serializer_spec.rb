require 'spec_helper'

describe Abroad::Serializers::Yaml::RailsSerializer do
  let(:stream) { StringIO.new }
  let(:locale) { 'fr' }
  let(:serializer) do
    Abroad::Serializers::Yaml::RailsSerializer.new(stream, locale)
  end

  def serialize
    yield
    serializer.flush
    YAML.load(stream.string)
  end

  it 'writes key/value pairs' do
    result = serialize do
      serializer.write_key_value('foo', 'bar')
    end

    expect(result).to eq('fr' => { 'foo' => 'bar' })
  end

  it 'nests dotted keys' do
    result = serialize do
      serializer.write_key_value('foo.bar.baz', 'boo')
    end

    expect(result).to eq({
      'fr' => { 'foo' => { 'bar' => { 'baz' => 'boo' } } }
    })
  end

  it "doesn't strip trailing periods" do
    result = serialize do
      serializer.write_key_value('timezones.Solomon Is.', 'val')
    end

    expect(result).to eq({
      'fr' => {
        'timezones' => {
          'Solomon Is.' => 'val'
        }
      }
    })
  end

  it 'strips trailing periods if they exist in the middle of the key' do
    result = serialize do
      serializer.write_key_value('timezones.Solomon Is.foobar', 'val')
    end

    expect(result).to eq({
      'fr' => {
        'timezones' => {
          'Solomon Is' => {
            'foobar' => 'val'
          }
        }
      }
    })
  end

  it "doesn't strip double periods" do
    result = serialize do
      serializer.write_key_value('timezones.Solomon Is..foobar', 'val')
    end

    expect(result).to eq({
      'fr' => {
        'timezones' => {
          'Solomon Is.' => {
            'foobar' => 'val'
          }
        }
      }
    })
  end

  it "doesn't split at periods if they exist before a space" do
    result = serialize do
      serializer.write_key_value('timezones.St. Petersburg.foobar', 'val')
    end

    expect(result).to eq({
      'fr' => {
        'timezones' => {
          'St. Petersburg' => {
            'foobar' => 'val'
          }
        }
      }
    })
  end

  it 'writes multiple key/value pairs independent of order' do
    result = serialize do
      serializer.write_key_value('i.like.burritos', 'beanz')
      serializer.write_key_value('ham.cheese', 'sandwich')
      serializer.write_key_value('i.like.cheesy.burritos', 'yum')
      serializer.write_key_value('ham.lettuce', 'crunchay')
    end

    expect(result).to eq({
      'fr' => {
        'i' => {
          'like' => {
            'burritos' => 'beanz',
            'cheesy' => {
              'burritos' => 'yum'
            }
          }
        },
        'ham' => {
          'cheese' => 'sandwich',
          'lettuce' => 'crunchay'
        }
      }
    })
  end

  it 'writes arrays for sequential keys' do
    result = serialize do
      serializer.write_key_value('foo.1', 'b')
      serializer.write_key_value('foo.0', 'a')
      serializer.write_key_value('foo.2', 'c')
    end

    expect(result).to eq({
      'fr' => { 'foo' => ['a', 'b', 'c'] }
    })
  end

  it 'writes successfully if given an array object instead of a string' do
    result = serialize do
      serializer.write_key_value('foo.bar', %w(a b c))
    end

    expect(result).to eq({
      'fr' => { 'foo' => { 'bar' => %w(a b c) } }
    })
  end

  it 'does not write arrays for sequential but non-numeric keys' do
    result = serialize do
      serializer.write_key_value('foo.bar1', 'b')
      serializer.write_key_value('foo.bar0', 'a')
      serializer.write_key_value('foo.bar2', 'c')
    end

    expect(result).to eq({
      'fr' => {
        'foo' => {
          'bar1' => 'b',
          'bar0' => 'a',
          'bar2' => 'c'
        }
      }
    })
  end

  it 'works for nested arrays' do
    result = serialize do
      serializer.write_key_value('foo', [
        { 'bar' => %w(a b), 'baz' => 'boo' },
        { 'bar' => %w(c d), 'baz' => 'bop' }
      ])
    end

    expect(result).to eq({
      'fr' => {
        'foo' => [
          { 'bar' => %w(a b), 'baz' => 'boo' },
          { 'bar' => %w(c d), 'baz' => 'bop' }
        ]
      }
    })
  end

  it 'writes nested key/value pairs and arrays (in any order)' do
    result = serialize do
      serializer.write_key_value('foo.0.bar.0', 'a')
      serializer.write_key_value('foo.0.bar.1', 'b')
      serializer.write_key_value('foo.1.bar.0', 'c')
      serializer.write_key_value('foo.1.bar.1', 'd')
    end

    expect(result).to eq({
      'fr' => {
        'foo' => [
          { 'bar' => ['a', 'b'] },
          { 'bar' => ['c', 'd'] }
        ]
      }
    })
  end

  it 'unquotes but stringifies numeric keys' do
    result = serialize do
      serializer.write_key_value("status_codes.'201'", 'Created')
      serializer.write_key_value("status_codes.'304'", 'Redirect')
      serializer.write_key_value("status_codes.'500'", 'Server error')
    end

    expect(result).to eq({
      'fr' => {
        'status_codes' => {
          '201' => 'Created',
          '304' => 'Redirect',
          '500' => 'Server error'
        }
      }
    })
  end

  it 'writes ints and floats correctly' do
    result = serialize do
      serializer.write_key_value('foo', '3')
      serializer.write_key_value('bar', '3.14')
      serializer.write_key_value('baz', '.')
    end

    expect(result).to eq({
      'fr' => {
        'foo' => 3,
        'bar' => 3.14,
        'baz' => '.'
      }
    })
  end
end
