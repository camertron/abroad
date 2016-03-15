module Abroad
  module Extractors
    module Json

      class JsonExtractor
        def extract_each(json_content, &block)
          if block_given?
            parse(json_content, &block)
          else
            to_enum(__method__, json_content)
          end
        end
      end

    end
  end
end
