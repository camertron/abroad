require 'json/stream'

module Abroad
  module Extractors
    module Json

      class DottedKeyExtractor < JsonExtractor

        private

        def each_entry
          key = []
          nesting_stack = []

          parser = ::JSON::Stream::Parser.new.tap do |parser|
            parser.key { |k| key.push(k) }

            parser.value do |val|
              yield key.join('.'), val

              case nesting_stack.last
                when :object
                  key.pop

                when :array
                  key[-1] += 1
              end
            end

            parser.start_array do
              nesting_stack.push(:array)
              key.push(0)
            end

            parser.end_array do
              nesting_stack.pop
              key.pop

              if nesting_stack.last == :object
                key.pop
              else
                key[-1] += 1
              end
            end

            parser.start_object do
              nesting_stack.push(:object)
            end

            parser.end_object do
              nesting_stack.pop
              key.pop
            end
          end

          parser << stream.read
        rescue ::JSON::Stream::ParserError => e
          raise Abroad::SyntaxError, "Syntax error in json: #{e.message}"
        end

      end
    end
  end
end
