module Abroad
  module Serializers

    class Serializer
      attr_reader :stream, :locale, :encoding

      class << self
        def from_stream(stream, locale)
          serializer = new(stream, locale)

          if block_given?
            yield serializer
            serializer.close
          else
            serializer
          end
        end

        def open(file, locale)
          from_stream(File.open(file), locale)
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

      def close
        flush
        stream.close
      end
    end

  end
end
