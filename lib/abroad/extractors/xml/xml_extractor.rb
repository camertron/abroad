require 'nokogiri'

module Abroad
  module Extractors
    module Xml

      class XmlExtractor < Extractor
        def extract_each(&block)
          if block_given?
            each_entry(&block)
          else
            to_enum(__method__)
          end
        end

        private

        def parse
          Nokogiri::XML(stream) do |config|
            # don't allow network connections
            config.options = Nokogiri::XML::ParseOptions::NONET
          end
        end
      end

    end
  end
end
