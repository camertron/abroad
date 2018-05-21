module Abroad
  module Serializers
    module Json
      autoload :JsonSerializer, 'abroad/serializers/json/json_serializer'
      autoload :KeyValueSerializer, 'abroad/serializers/json/key_value_serializer'
      autoload :DottedKeySerializer, 'abroad/serializers/json/dotted_key_serializer'
    end
  end
end
