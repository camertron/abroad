require 'spec_helper'

include Abroad::Serializers

describe Json::DottedKeySerializer do
  let(:stream) { StringIO.new }
  let(:locale) { 'fr-FR' }

  let(:serializer) do
    Json::DottedKeySerializer.new(stream, locale)
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

    expect(result).to eq("{\"com\":{\"foo\":{\"bar\":\"baz\"}}}")
  end
end
