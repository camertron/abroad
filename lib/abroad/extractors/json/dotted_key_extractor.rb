module Abroad
  module Extractors
    module Json

      class DottedKeyExtractor < JsonExtractor
        private

        def each_entry(options = {}, &block)
          walk(parse, [], options, &block)
        end

        def parse
          JSON.parse(stream.read)
        rescue JSON::ParserError => e
          raise Abroad::SyntaxError, "Syntax error in yaml: #{e.message}"
        end

        def walk(obj, cur_path, options, &block)
          case obj
            when Hash
              obj.each_pair do |key, val|
                segment = is_numeric?(key) ? "'#{key}'" : key
                walk(val, cur_path + [segment], options, &block)
              end
            when Array
              if options[:preserve_arrays] && string_array?(obj)
                yield cur_path.join('.'), obj
              else
                obj.each_with_index do |val, idx|
                  walk(val, cur_path + [idx.to_s], options, &block)
                end
              end
            else
              yield cur_path.join('.'), obj
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

        def is_numeric?(str)
          !!(str.to_s =~ /\A\d+\z/)
        end
      end

    end
  end
end
