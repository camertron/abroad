module Abroad
  module Serializers
    module Json

      class KeyValueSerializer < JsonSerializer
        DEFAULT_INDENT_SPACES = 4

        def initialize(stream, locale, options = {})
          super
          writer.write_object
        end

        def write_key_value(key, value)
          before = pretty? ? "\n#{' ' * indent_spaces}" : ''

          writer.write_key_value(
            key.encode(encoding), value.encode(encoding), before
          )
        end

        def close
          write_raw("\n") if pretty?
          writer.close_object
          super
        end

        private

        def indent_spaces
          options.fetch(:indent_spaces, DEFAULT_INDENT_SPACES)
        end

        def pretty?
          options.fetch(:pretty, true)
        end
      end

    end
  end
end
