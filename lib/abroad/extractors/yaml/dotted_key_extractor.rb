module Abroad
  module Extractors
    module Yaml

      class DottedKeyExtractor < YamlExtractor
        private

        def each_entry(yaml_content, &block)
          walk(parse(yaml_content), [], &block)
        end

        def walk(obj, cur_path, &block)
          case obj
            when Hash
              obj.each_pair do |key, val|
                walk(val, cur_path + [key], &block)
              end
            when Array
              obj.each_with_index do |val, idx|
                walk(val, cur_path + [idx.to_s], &block)
              end
            else
              yield scrub_path(cur_path).join('.'), obj
          end
        end

        private

        def scrub_path(path)
          path  # no-op
        end
      end

    end
  end
end
