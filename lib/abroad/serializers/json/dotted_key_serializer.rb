module Abroad
  module Serializers
    module Json

      class DottedKeySerializer < JsonSerializer
        attr_reader :trie

        def initialize(stream, locale, options = {})
          super
          @trie = Abroad::Serializers::Trie.new
        end

        def write_key_value(key, value)
          trie.add(key.split('.'), encode(value))
        end

        def flush
          write_node(trie.root, nil)
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

        def write_node(node, parent_key)
          if node
            if node.has_children?
              if children_are_sequence?(node)
                write_array(node, parent_key)
              else
                write_object(node, parent_key)
              end
            elsif node.has_value?
              write_value(node, parent_key)
            end
          else
            write_value(node, parent_key)
          end
        end

        def write_value(node, parent_key)
          value = node ? node.value : ''

          if writer.in_object?
            writer.write_key_value(parent_key, value)
          else
            writer.write_element(value)
          end
        end

        def write_object(node, parent_key)
          if writer.in_object?
            writer.write_object(parent_key)
          else
            writer.write_object
          end

          node.each_child do |key, child|
            write_node(child, key)
          end

          writer.close_object
        end

        def write_array(node, parent_key)
          if writer.in_object?
            writer.write_array(parent_key)
          else
            writer.write_array
          end

          generate_sequence(node).each do |element|
            write_node(element, nil)
          end

          writer.close_array
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
