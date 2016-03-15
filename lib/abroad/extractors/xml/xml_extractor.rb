require 'nokogiri'

module Abroad
  module Extractors
    module Xml

      class XmlExtractor
        def extract_each(xml_content, &block)
          if block_given?
            each_entry(xml_content, &block)
          else
            to_enum(__method__, xml_content)
          end
        end

        private

        def parse(xml_content)
          Nokogiri::XML(xml_content) do |config|
            # don't allow network connections
            config.options = Nokogiri::XML::ParseOptions::NONET
          end
        end
      end

    end
  end
end
