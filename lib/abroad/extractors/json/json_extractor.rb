module Abroad
  module Extractors
    module Json

      class JsonExtractor < Extractor
        def extract_each(options = {}, &block)
          if block_given?
            each_entry(&block)
          else
            to_enum(__method__, options)
          end
        end
      end

    end
  end
end
