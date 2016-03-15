module Abroad
  module Serializers
    autoload :Json,       'abroad/serializers/json'
    autoload :Serializer, 'abroad/serializers/serializer'
    autoload :Trie,       'abroad/serializers/trie'
    autoload :Xml,        'abroad/serializers/xml'
    autoload :Yaml,       'abroad/serializers/yaml'
  end
end
