module Abroad
  module Extractors
    autoload :Extractor, 'abroad/extractors/extractor'
    autoload :Json,      'abroad/extractors/json'
    autoload :Txt,       'abroad/extractors/txt'
    autoload :Xml,       'abroad/extractors/xml'
    autoload :Yaml,      'abroad/extractors/yaml'

    class << self
      def register(id, klass)
        registered[id.to_s] = klass
      end

      def get(id)
        registered[id.to_s]
      end

      def available
        registered.keys
      end

      private

      def registered
        @registered ||= {}
      end
    end
  end
end
