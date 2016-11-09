require 'spec_helper'

include Abroad::Serializers

describe Txt::LinesSerializer do
  let(:stream) { StringIO.new }
  let(:locale) { 'en' }
  let(:serializer) { described_class.from_stream(stream, locale) }

  it 'writes key/value pairs' do
    serializer.write_key_value('2', 'foo')
    serializer.write_key_value('3', 'bar')
    serializer.write_key_value('5', 'baz')

    serializer.close
    expect(stream.string).to eq(outdent(%Q(


      foo
      bar

      baz
    )).rstrip)
  end

  it 'raises an error if given a non-numeric key' do
    expect { serializer.write_key_value('abc', 'def') }.to(
      raise_error(KeyError)
    )
  end
end
