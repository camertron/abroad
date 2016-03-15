module Abroad
  module Extractors
    module Yaml
      autoload :DottedKeyExtractor, 'abroad/extractors/yaml/dotted_key_extractor'
      autoload :RailsExtractor,     'abroad/extractors/yaml/rails_extractor'
      autoload :YamlExtractor,      'abroad/extractors/yaml/yaml_extractor'
    end
  end
end
