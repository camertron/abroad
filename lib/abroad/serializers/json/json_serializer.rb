require 'json-write-stream'

module Abroad
  module Serializers
    module Json

      class JsonSerializer < Serializer
        attr_reader :writer

        def initialize(stream, locale, options = {})
          super
          @writer = JsonWriteStream.from_stream(stream, options)
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
