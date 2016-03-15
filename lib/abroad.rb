module Abroad
  class SyntaxError < StandardError; end

  autoload :Extractors,  'abroad/extractors'
  autoload :Serializers, 'abroad/serializers'

  Extractors.register('yaml/rails', Extractors::Yaml::RailsExtractor)
  Extractors.register('yaml/dotted-key', Extractors::Yaml::DottedKeyExtractor)
  Extractors.register('json/key-value', Extractors::Json::KeyValueExtractor)
  Extractors.register('xml/android', Extractors::Xml::AndroidExtractor)

  Serializers.register('yaml/rails', Serializers::Yaml::RailsSerializer)
  Serializers.register('json/key-value', Serializers::Json::KeyValueSerializer)
  Serializers.register('xml/android', Serializers::Xml::AndroidSerializer)

  class << self
    def extractor(id)
      Extractors.get(id).new
    end

    def serializer(id)
      Serializers.get(id)
    end
  end
end
