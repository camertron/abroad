module Abroad
  module Extractors
    module Yaml

      class DottedKeyExtractor < YamlExtractor
        def extract_each(options = {}, &block)
          return to_enum(__method__, options) unless block_given?
          walk(parse, [], options, &block)
        end

        private

        def walk(obj, cur_path, options, &block)
          case obj
            when Hash
              obj.each_pair do |key, val|
                segment = is_numeric?(key) ? "'#{key}'" : key
                walk(val, cur_path + [segment], options, &block)
              end
            when Array
              if options[:preserve_arrays] && string_array?(obj)
                yield scrub_path(cur_path).join('.'), obj
              else
                obj.each_with_index do |val, idx|
                  walk(val, cur_path + [idx.to_s], options, &block)
                end
              end
            else
              yield scrub_path(cur_path).join('.'), obj
          end
        end

        def string_array?(arr)
          arr.all? do |elem|
            case elem
              when Hash, Array
                false
              else
                true
            end
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
