module Abroad
  module Serializers
    module Json

      class KeyValueSerializer < JsonSerializer
        def initialize(stream, locale, encoding = Encoding::UTF_8)
          super
          writer.write_object
        end

        def write_key_value(key, value)
          writer.write_key_value(
            key.encode(encoding), value.encode(encoding)
          )
        end
      end

    end
  end
end
