require 'spec_helper'

include Abroad::Serializers

describe Json::DottedKeySerializer do
  let(:stream) { StringIO.new }
  let(:locale) { 'fr-FR' }

  let(:serializer) do
    Json::DottedKeySerializer.new(stream, locale, pretty: true)
  end

  def serialize
    yield
    serializer.flush
    stream.string
  end

  it 'writes key/value pairs' do
    result = serialize do
      serializer.write_key_value('com.foo.bar', 'baz')
    end

    expect(result).to eq(<<~END.strip)
      {
        "com": {
          "foo": {
            "bar": "baz"
          }
        }
      }
    END
  end

  it 'writes sequences' do
    result = serialize do
      serializer.write_key_value('baz.boo.0', 'elem1')
      serializer.write_key_value('baz.boo.1', 'elem2')
    end

    expect(result).to eq(<<~END.strip)
      {
        "baz": {
          "boo": [
            "elem1",
            "elem2"
          ]
        }
      }
    END
  end
end
