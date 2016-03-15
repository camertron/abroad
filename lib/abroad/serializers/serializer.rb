module Abroad
  module Serializers

    class Serializer
      attr_reader :stream, :locale, :encoding

      class << self
        def from_stream(stream, locale)
          new(stream, locale)
        end

        def open(file, locale)
          new(File.open(file), locale)
        end

        def default_extension
          raise NotImplementedError,
            'expected to be implemented in derived classes'
        end
      end

      def initialize(stream, locale, encoding = Encoding::UTF_8)
        @stream = stream
        @locale = locale
        @encoding = encoding
      end

      def write_key_value(key, value)
        raise NotImplementedError,
          'expected to be implemented in derived classes'
      end

      def write_raw(text)
        raise NotImplementedError,
          'expected to be implemented in derived classes'
      end

      def flush
        stream.flush
      end
    end

  end
end
