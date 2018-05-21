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
          writer.write_key_value(
            key.encode(encoding), value.encode(encoding), write_options
          )
        end

        def close
          write_raw("\n") if pretty?
          writer.close_object
          super
        end

        private

        def write_options
          @write_options ||= { before: before_text, between: between_text }
        end

        def before_text
          @before_text ||= pretty? ? "\n#{' ' * indent_spaces}" : ''
        end

        def between_text
          @between_text ||= pretty? ? ' ' : ''
        end

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
