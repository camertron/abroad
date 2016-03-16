require 'yaml'

module Abroad
  module Extractors
    module Yaml

      class YamlExtractor < Extractor
        private

        def parse
          YAML.load(clean_yaml(stream.read))
        rescue Psych::SyntaxError => e
          raise Abroad::SyntaxError, "Syntax error in yaml: #{e.message}"
        end

        def clean_yaml(yaml_content)
          if Abroad.jruby?
            require 'abroad/extractors/yaml/jruby_compat'
            JRubyCompat.clean(yaml_content)
          else
            yaml_content
          end
        end
      end

    end
  end
end
