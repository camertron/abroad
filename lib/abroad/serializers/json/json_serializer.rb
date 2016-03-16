require 'json-write-stream'

module Abroad
  module Serializers
    module Json

      class JsonSerializer < Serializer
        attr_reader :writer

        def initialize(stream, locale, encoding = Encoding::UTF_8)
          super
          @writer = JsonWriteStream.from_stream(stream, encoding)
        end

        def write_raw(text)
          writer.stream.write(text)
        end

        def flush
          writer.flush
          stream.flush
        end
      end

    end
  end
end
