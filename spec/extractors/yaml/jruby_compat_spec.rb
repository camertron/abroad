# encoding: UTF-8

require 'spec_helper'

if Abroad.jruby?
  require 'abroad/extractors/yaml/jruby_compat'

  describe 'JRubyCompat' do
    let(:compat) { Abroad::Extractors::Yaml::JRubyCompat }

    describe 'clean' do
      it 'replaces escaped single quotes in key/value pairs' do
        yaml = "foo:\n" +
          "  bar: \"baz\\'boo\""

        expect { YAML.load(yaml) }.to raise_error(Psych::SyntaxError)
        expect(YAML.load(compat.clean(yaml))).to eq({
          'foo' => { 'bar' => "baz'boo" }
        })
      end

      it 'replaces escaped single quotes in array elements' do
        yaml = "foo:\n" +
          "  - abc\n" +
          "  - \"def\\'ghi\""

        expect { YAML.load(yaml) }.to raise_error(Psych::SyntaxError)
        expect(YAML.load(compat.clean(yaml))).to eq({
          'foo' => ['abc', "def'ghi"]
        })
      end

      it 'does not replace escaped single quotes that occur outside of double quotes' do
        yaml = "foo:\n" +
          "  bar: abc\\'def"

        expect { YAML.load(yaml) }.to_not raise_error
        expect(YAML.load(compat.clean(yaml))).to eq({
          'foo' => { 'bar' => "abc\\'def" }
        })
      end

      it 'does not replace escaped single quotes that occur outside of double quotes in arrays' do
        yaml = "foo:\n" +
          "  - def\\'ghi"

        expect { YAML.load(yaml) }.to_not raise_error
        expect(YAML.load(compat.clean(yaml))).to eq({
          'foo' => ["def\\'ghi"]
        })
      end
    end
  end
end
