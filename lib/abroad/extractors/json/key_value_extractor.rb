require 'json/stream'

module Abroad
  module Extractors
    module Json

      class KeyValueExtractor < JsonExtractor
        private

        def each_entry
          open_obj_count = 0
          open_array_count = 0
          key = nil

          parser = ::JSON::Stream::Parser.new.tap do |parser|
            parser.key { |key_str| key = key_str }

            parser.value do |value_str|
              if block_given? && open_array_count.zero? && open_obj_count == 1
                yield key, value_str
              end
            end

            parser.start_object { open_obj_count += 1 }
            parser.end_object { open_obj_count -= 1 }
            parser.start_array { open_array_count += 1 }
            parser.end_array { open_array_count -= 1 }
          end

          parser << stream.read
        rescue ::JSON::Stream::ParserError => e
          raise Abroad::SyntaxError, "Syntax error in json: #{e.message}"
        end
      end

    end
  end
end
