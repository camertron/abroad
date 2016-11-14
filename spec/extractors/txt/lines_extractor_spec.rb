require 'spec_helper'

include Abroad::Extractors

describe Txt::LinesExtractor do
  it 'extracts text into lines' do
    text = outdent(%Q(
      foo

      bar

      baz
      boo
    ))

    strings = described_class.from_string(text).extract_each.to_a

    expect(strings).to eq([
      ['0', 'foo'], ['1', ''],    ['2', 'bar'],
      ['3', ''],    ['4', 'baz'], ['5', 'boo']
    ])
  end
end
