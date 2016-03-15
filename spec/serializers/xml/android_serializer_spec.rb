require 'spec_helper'
require 'yaml'

include Abroad::Serializers

# NOTE: The use of YAML in these specs is only to make writing multi-line
# indented strings easier to read and write
describe Xml::AndroidSerializer do
  let(:stream) { StringIO.new }
  let(:locale) { 'fr-FR' }

  let(:serializer) do
    Xml::AndroidSerializer.new(stream, locale)
  end

  def serialize
    yield
    serializer.flush
    stream.string
  end

  it 'writes key/value pairs' do
    result = serialize do
      serializer.write_key_value('foo', 'bar')
    end

    expect(result).to eq(YAML.load(<<-EOM
      |
        <?xml version="1.0" encoding="UTF-8"?>
        <resources>
            <string name="foo">bar</string>
        </resources>
      EOM
    ).strip)
  end

  it 'detects and writes plurals' do
    result = serialize do
      serializer.write_key_value('horses.one', 'There is one horse')
      serializer.write_key_value('horses.other', 'There are %d horses')
    end

    expect(result).to eq(YAML.load(<<-EOM
      |
        <?xml version="1.0" encoding="UTF-8"?>
        <resources>
            <plurals name="horses">
                <item quantity="one">There is one horse</item>
                <item quantity="other">There are %d horses</item>
            </plurals>
        </resources>
      EOM
    ).strip)
  end

  it 'detects and writes arrays in any order' do
    result = serialize do
      serializer.write_key_value('captains.1', 'Kirk')
      serializer.write_key_value('captains.3', 'Sisko')
      serializer.write_key_value('captains.0', 'Janeway')
      serializer.write_key_value('captains.2', 'Picard')
    end

    expect(result).to eq(YAML.load(<<-EOM
      |
        <?xml version="1.0" encoding="UTF-8"?>
        <resources>
            <string-array name="captains">
                <item>Janeway</item>
                <item>Kirk</item>
                <item>Picard</item>
                <item>Sisko</item>
            </string-array>
        </resources>
      EOM
    ).strip)
  end

  it "doesn't escape entities" do
    result = serialize do
      serializer.write_key_value('states', "Alaska & Hawai'i")
    end

    expect(result).to eq(YAML.load(<<-EOM
      |
        <?xml version="1.0" encoding="UTF-8"?>
        <resources>
            <string name="states">Alaska &amp; Hawai\\'i</string>
        </resources>
      EOM
    ).strip)
  end

  it "doesn't escape html elements" do
    result = serialize do
      serializer.write_key_value('captain', "<b>Jean Luc</b> Picard")
    end

    expect(result).to eq(YAML.load(<<-EOM
      |
        <?xml version="1.0" encoding="UTF-8"?>
        <resources>
            <string name="captain"><b>Jean Luc</b> Picard</string>
        </resources>
      EOM
    ).strip)
  end

  it 'escapes double quotes' do
    result = serialize do
      serializer.write_key_value('wow', 'And I said "cool"')
    end

    expect(result).to eq(YAML.load(<<-EOM
      |
        <?xml version="1.0" encoding="UTF-8"?>
        <resources>
            <string name="wow">And I said \\"cool\\"</string>
        </resources>
      EOM
    ).strip)
  end

  it 'escapes double quotes at the beginning of a string' do
    result = serialize do
      serializer.write_key_value('wow', '"Elvis" is cool')
    end

    expect(result).to eq(YAML.load(<<-EOM
      |
        <?xml version="1.0" encoding="UTF-8"?>
        <resources>
            <string name="wow">\\"Elvis\\" is cool</string>
        </resources>
      EOM
    ).strip)
  end

  it 'writes a mixture of all types of string' do
    result = serialize do
      serializer.write_key_value('justaplural.many', 'Many plurals')
      serializer.write_key_value('justanarray.1', 'Second in line')
      serializer.write_key_value('justanarray.0', 'First in line')
      serializer.write_key_value('justastring', "I'm very basic")
      serializer.write_key_value('justaplural.one', 'One plural')
    end

    expect(result).to eq(YAML.load(<<-EOM
      |
        <?xml version="1.0" encoding="UTF-8"?>
        <resources>
            <string name="justastring">I\\'m very basic</string>
            <plurals name="justaplural">
                <item quantity="many">Many plurals</item>
                <item quantity="one">One plural</item>
            </plurals>
            <string-array name="justanarray">
                <item>First in line</item>
                <item>Second in line</item>
            </string-array>
        </resources>
      EOM
    ).strip)
  end
end
