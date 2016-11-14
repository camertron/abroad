require 'pry-byebug' if RUBY_ENGINE == 'ruby'
require 'rake'
require 'rspec'
require 'abroad'
require 'yaml'

module SpecHelpers
  def outdent(str)
    # The special YAML pipe operator treats the text that follows as literal,
    # and includes newlines, tabs, and spaces. It also strips leading tabs and
    # spaces. This means you can include a fully indented bit of, say, source
    # code in your source code, and it will give you back a string with all the
    # indentation preserved (but without any leading indentation).
    YAML.load("|#{str}")
  end
end

RSpec.configure do |config|
  config.include(SpecHelpers)

  shared_examples 'a fixture-based extractor' do |dir, namespace|
    fixture_manifest = YAML.load_file(File.join(dir, 'fixtures.yml'))
    fixture_dir = File.join(dir, 'fixtures')

    fixture_manifest.each_pair do |extractor_name, expected_results|
      describe extractor_name do
        let(:extractor) do
          Abroad.extractor(extractor_name)
        end

        expected_results.each_pair do |expected_file, expected_phrases|
          it "extracts phrases correctly from #{expected_file}" do
            source_file = File.join(fixture_dir, expected_file)

            extractor.open(source_file).extract_each do |actual_key, actual_string|
              expected_string_index = expected_phrases.find_index do |expected_phrase|
                expected_phrase['key'] == actual_key
              end

              expected_phrase = expected_phrases[expected_string_index]
              expect(expected_phrase).to_not be_nil
              expect(expected_phrase['string']).to eq(actual_string)
              expected_phrases.delete_at(expected_string_index)
            end

            expect(expected_phrases).to be_empty
          end
        end
      end
    end
  end
end
