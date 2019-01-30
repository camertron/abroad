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
            key.encode(encoding), value.encode(encoding)
          )
        end

        def close
          write_raw("\n") if pretty?
          writer.close_object
          super
        end
      end

    end
  end
end
