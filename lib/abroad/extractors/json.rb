module Abroad
  module Extractors
    module Json
      autoload :JsonExtractor,     'abroad/extractors/json/json_extractor'
      autoload :KeyValueExtractor, 'abroad/extractors/json/key_value_extractor'
      autoload :DottedKeyExtractor,   'abroad/extractors/json/dotted_key_extractor'
    end
  end
end
