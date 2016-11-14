require 'stringio'

module Abroad
  module Serializers
    module Txt

      class TxtSerializer < Serializer
        def write_raw(text)
          stream.write(text)
        end
      end

    end
  end
end
