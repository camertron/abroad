module Abroad
  module Extractors
    autoload :Json, 'abroad/extractors/json'
    autoload :Xml,  'abroad/extractors/xml'
    autoload :Yaml, 'abroad/extractors/yaml'

    class << self
      def register(id, klass)
        registered[id] = klass
      end

      def get(id)
        registered[id]
      end

      private

      def registered
        @registered ||= {}
      end
    end
  end
end
