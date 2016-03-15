require 'yaml'
require 'yaml-write-stream'

module Abroad
  module Serializers
    module Yaml

      class YamlSerializer < Serializer
        attr_reader :writer

        def initialize(stream, locale, encoding = Encoding::UTF_8)
          super
          @writer = YamlWriteStream.from_stream(stream, encoding)
        end

        def self.default_extension
          '.yml'
        end
      end

    end
  end
end
