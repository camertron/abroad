require 'spec_helper'

include Abroad::Serializers

describe Json::KeyValueSerializer do
  let(:stream) { StringIO.new }
  let(:locale) { 'fr-FR' }

  let(:serializer) do
    Json::KeyValueSerializer.new(stream, locale, pretty: true)
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

    expect(result).to eq("{\n  \"foo\": \"bar\"\n}")
  end
end
