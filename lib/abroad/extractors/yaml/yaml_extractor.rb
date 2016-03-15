require 'yaml'

module Abroad
  module Extractors
    module Yaml

      class YamlExtractor
        def extract_each(yaml_content, &block)
          if block_given?
            each_entry(yaml_content, &block)
          else
            to_enum(__method__, yaml_content)
          end
        end

        private

        def parse(yaml_content)
          YAML.load(yaml_content)
        rescue Psych::SyntaxError => e
          raise Abroad::SyntaxError, "Syntax error in yaml: #{e.message}"
        end
      end

    end
  end
end
