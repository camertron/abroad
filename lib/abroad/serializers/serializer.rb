module Abroad
  module Serializers

    class Serializer
      DEFAULT_ENCODING = Encoding::UTF_8

      attr_reader :stream, :locale, :options

      class << self
        def from_stream(stream, locale)
          serializer = new(stream, locale)

          if block_given?
            yield(serializer).tap do
              serializer.close
            end
          else
            serializer
          end
        end

        def open(file, locale, &block)
          from_stream(File.open(file), locale, &block)
        end
      end

      def initialize(stream, locale, options = {})
        @stream = stream
        @locale = locale
        @options = options
      end

      def encoding
        options.fetch(:encoding, DEFAULT_ENCODING)
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
