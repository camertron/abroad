module Abroad
  class SyntaxError < StandardError; end

  autoload :Extractors,  'abroad/extractors'
  autoload :Serializers, 'abroad/serializers'

  Extractors.register('yaml/rails', Extractors::Yaml::RailsExtractor)
  Extractors.register('yaml/dotted-key', Extractors::Yaml::DottedKeyExtractor)
  Extractors.register('json/key-value', Extractors::Json::KeyValueExtractor)
  Extractors.register('xml/android', Extractors::Xml::AndroidExtractor)
  Extractors.register('txt/lines', Extractors::Txt::LinesExtractor)

  Serializers.register('yaml/rails', Serializers::Yaml::RailsSerializer)
  Serializers.register('json/key-value', Serializers::Json::KeyValueSerializer)
  Serializers.register('xml/android', Serializers::Xml::AndroidSerializer)
  Serializers.register('txt/lines', Serializers::Txt::LinesSerializer)

  class << self
    def extractors
      Extractors.available
    end

    def extractor(id)
      Extractors.get(id)
    end

    def serializers
      Serializers.available
    end

    def serializer(id)
      Serializers.get(id)
    end

    def jruby?
      RUBY_ENGINE == 'jruby'
    end
  end
end
