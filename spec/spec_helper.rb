require 'pry-byebug'
require 'rake'
require 'rspec'
require 'abroad'
require 'yaml'

RSpec.configure do |config|
  def camelize(str)
    str.gsub(/(^\w|[-_]\w)/) { $1[-1].upcase }
  end

  shared_examples 'a fixture-based extractor' do |dir, namespace|
    fixture_manifest = YAML.load_file(File.join(dir, 'fixtures.yml'))
    fixture_dir = File.join(dir, 'fixtures')

    fixture_manifest.each_pair do |extractor_name, expected_results|
      describe extractor_name do
        let(:extractor) do
          capitalized_name = camelize(extractor_name.to_s)
          namespace.const_get("#{capitalized_name}Extractor").new
        end

        expected_results.each_pair do |expected_file, expected_phrases|
          it "extracts phrases correctly from #{expected_file}" do
            source_file = File.join(fixture_dir, expected_file)
            contents = File.read(source_file)

            extractor.extract_each(contents).each do |actual_key, actual_string|
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
