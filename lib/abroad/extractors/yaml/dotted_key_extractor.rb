module Abroad
  module Extractors
    module Yaml

      class DottedKeyExtractor < YamlExtractor
        def extract_each(&block)
          if block_given?
            walk(parse, [], &block)
          else
            to_enum(__method__)
          end
        end

        private

        def walk(obj, cur_path, &block)
          case obj
            when Hash
              obj.each_pair do |key, val|
                segment = is_numeric?(key) ? "'#{key}'" : key
                walk(val, cur_path + [segment], &block)
              end
            when Array
              obj.each_with_index do |val, idx|
                walk(val, cur_path + [idx.to_s], &block)
              end
            else
              yield scrub_path(cur_path).join('.'), obj
          end
        end

        def scrub_path(path)
          path  # no-op
        end

        def is_numeric?(str)
          !!(str.to_s =~ /\A\d+\z/)
        end
      end

    end
  end
end
