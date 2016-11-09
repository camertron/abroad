module Abroad
  module Serializers
    autoload :Json,       'abroad/serializers/json'
    autoload :Serializer, 'abroad/serializers/serializer'
    autoload :Txt,        'abroad/serializers/txt'
    autoload :Trie,       'abroad/serializers/trie'
    autoload :Xml,        'abroad/serializers/xml'
    autoload :Yaml,       'abroad/serializers/yaml'

    class << self
      def register(id, klass)
        registered[id] = klass
      end

      def get(id)
        registered[id]
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
