module Abroad
  module Extractors
    module Yaml

      class RailsExtractor < DottedKeyExtractor
        private

        def scrub_path(path)
          path[1..-1]
        end
      end

    end
  end
end
