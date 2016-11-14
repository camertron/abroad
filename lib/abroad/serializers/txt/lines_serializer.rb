module Abroad
  module Serializers
    module Txt

      class LinesSerializer < TxtSerializer
        DEFAULT_NEWLINE_SEPARATOR = "\n"

        attr_reader :newline_separator, :lines

        def initialize(stream, locale, options = {})
          @newline_separator = options.fetch(:newline_separator, DEFAULT_NEWLINE_SEPARATOR)
          @lines = []
          super
        end

        def write_key_value(key, value)
          unless valid_key?(key)
            raise KeyError, "'#{key}' is not a valid key"
          end

          add_line(key, value)
        end

        def flush
          stream.write(lines.join(newline_separator))
          super
        end

        private

        def add_line(key, value)
          key = parse_key(key)

          if key >= lines.size
            lines.concat(Array.new(key - lines.size + 1) { '' })
          end

          lines[key] = value
        end

        def parse_key(key)
          key.to_i
        end

        def valid_key?(key)
          !!(key =~ /[\d]+/)
        end
      end

    end
  end
end
