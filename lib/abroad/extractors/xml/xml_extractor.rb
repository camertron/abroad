require 'nokogiri'

module Abroad
  module Extractors
    module Xml

      class XmlExtractor < Extractor
        def extract_each(options = {}, &block)
          if block_given?
            each_entry(&block)
          else
            to_enum(__method__, options)
          end
        end

        private

        def parse
          options = Nokogiri::XML::ParseOptions.new.default_xml.nonet
          Nokogiri::XML(stream, nil, nil, options)
        end
      end

    end
  end
end
