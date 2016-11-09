require 'json/stream'

module Abroad
  module Extractors
    module Txt

      class LinesExtractor < TxtExtractor
        private

        def each_entry
          return to_enum(__method__) unless block_given?

          stream.read.split(/\r?\n/).each_with_index do |line, idx|
            # keys should always be strings
            yield idx.to_s, line
          end
        end
      end

    end
  end
end
