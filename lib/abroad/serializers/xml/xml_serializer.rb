require 'xml-write-stream'

module Abroad
  module Serializers
    module Xml

      class XmlSerializer < Serializer
        attr_reader :writer

        def initialize(stream, locale, encoding = Encoding::UTF_8)
          super
          @writer = XmlWriteStream.from_stream(stream)
          writer.write_header(encoding: encoding.to_s)
          after_initialize
        end

        def after_initialize
        end
      end

    end
  end
end
