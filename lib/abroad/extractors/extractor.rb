require 'stringio'

module Abroad
  module Extractors

    class Extractor
      attr_reader :stream

      class << self
        def from_stream(stream)
          extractor = new(stream)

          if block_given?
            yield extractor
            extractor.close
          else
            extractor
          end
        end

        def from_string(string)
          from_stream(StringIO.new(string))
        end

        def open(file)
          from_stream(File.open(file, 'r'))
        end
      end

      def initialize(stream)
        @stream = stream
      end

      def extract_each
        raise NotImplementedError,
          'expected to be implemented in derived classes'
      end

      def close
        stream.close
      end
    end

  end
end
