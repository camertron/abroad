require 'stringio'

module Abroad
  module Extractors

    class Extractor
      attr_reader :stream

      class << self
        def from_stream(stream)
          extractor = new(stream)

          if block_given?
            yield(extractor).tap do
              extractor.close
            end
          else
            extractor
          end
        end

        def from_string(string, &block)
          from_stream(StringIO.new(string), &block)
        end

        def open(file, mode = 'r', &block)
          from_stream(File.open(file, mode), &block)
        end
      end

      def initialize(stream)
        @stream = stream
      end

      def extract_each(options = {})
        raise NotImplementedError,
          'expected to be implemented in derived classes'
      end

      def close
        stream.close
      end
    end

  end
end
