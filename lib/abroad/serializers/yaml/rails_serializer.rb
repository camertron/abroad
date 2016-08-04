module Abroad
  module Serializers
    module Yaml

      class RailsSerializer < YamlSerializer
        attr_reader :trie

        def initialize(stream, locale, options = {})
          super
          @trie = Abroad::Serializers::Trie.new
        end

        def write_raw(text)
          writer.stream.write(text)
        end

        def write_key_value(key, value)
          key_parts = split_key(key)
          trie.add(key_parts, encode(value))
        end

        def flush
          writer.write_map(locale)
          write_node(trie.root, locale)
          writer.flush
          stream.flush
        end

        private

        def encode(value)
          case value
            when Array
              value.map { |elem| encode(elem) }
            else
              if value.respond_to?(:encode)
                value.encode(encoding)
              else
                value
              end
          end
        end

        def split_key(key)
          # Doesn't allow dots to come before spaces or at the end of the key.
          # Uses regex negative lookahead, that's what the (?!) sections are.
          # Examples:
          # 'timezones.Solomon Is.'     => ['timezones', 'Solomon Is.']
          # 'timezones.Solomon Is.foo'  => ['timezones', 'Solomon Is', 'foo']
          # 'timezones.Solomon Is..foo' => ['timezones', 'Solomon Is.', 'foo']
          key.split(/\.(?!\s)(?!\z)(?!\.)/)
        end

        def unquote_numeric(str)
          if match = str.match(/\A'(\d+)'\z/)
            match.captures.first
          else
            str
          end
        end

        # depth-first
        def write_node(node, parent_key)
          if node
            if node.has_children?
              if children_are_sequence?(node)
                write_sequence(node, parent_key)
              else
                write_map(node, parent_key)
              end
            elsif node.has_value?
              write_value(node, parent_key)
            end
          else
            write_value(node, parent_key)
          end
        end

        def write_value(node, parent_key)
          value = (node ? node.value : '') || ''

          case value
            when Array
              write_array_value(parent_key, value)
            else
              write_textual_value(parent_key, value)
          end
        end

        def coerce(value)
          # coerce numeric values
          case value
            when /\A\d+\z/
              value.to_i
            when /\A\d+\.\d+\z/
              value.to_f
            else
              value
          end
        end

        def write_textual_value(parent_key, value)
          value = coerce(value)

          if writer.in_map?
            writer.write_key_value(parent_key, value)
          else
            writer.write_element(value)
          end
        end

        def write_array_value(parent_key, elements)
          # we should _always_ be in a map, but just in case...
          writer.write_sequence(parent_key) if writer.in_map?

          elements.each do |element|
            writer.write_element(coerce(element))
          end

          writer.close_sequence
        end

        def write_map(node, parent_key)
          if writer.in_map?
            writer.write_map(parent_key)
          else
            writer.write_map
          end

          node.each_child do |key, child|
            write_node(child, unquote_numeric(key))
          end

          writer.close_map
        end

        def write_sequence(node, parent_key)
          if writer.in_map?
            writer.write_sequence(parent_key)
          else
            writer.write_sequence
          end

          generate_sequence(node).each do |element|
            write_node(element, nil)
          end

          writer.close_sequence
        end

        def children_are_sequence?(node)
          node.children.all? { |key, _| key =~ /\A[\d]+\z/ }
        end

        def generate_sequence(node)
          keys = node.children.keys.map(&:to_i)
          keys.each_with_object(Array.new(keys.max)) do |idx, arr|
            arr[idx] = node.children[idx.to_s]
          end
        end
      end

    end
  end
end
