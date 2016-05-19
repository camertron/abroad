require 'yaml'
require 'yaml-write-stream'

module Abroad
  module Serializers
    module Yaml

      class YamlSerializer < Serializer
        attr_reader :writer

        def initialize(stream, locale, options = {})
          super
          @writer = YamlWriteStream.from_stream(stream, encoding)
        end
      end

    end
  end
end
