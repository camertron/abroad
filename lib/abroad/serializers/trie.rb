module Abroad
  module Serializers

    class Trie
      attr_reader :root

      def initialize(root = nil)
        @root = root || TrieNode.new
      end

      def add(key_enum, value)
        node = root

        key_enum.each do |key|
          if node.has_child?(key)
            node = node.child_at(key)
          else
            node = node.add_child(key, TrieNode.new)
          end
        end

        node.value = value
      end

      def find(key_enum)
        node = root
        key_enum.each do |key|
          node = node.child_at(key)
          return nil unless node
        end
        node.value
      end
    end

    class TrieNode
      NO_VALUE = :__novalue__

      attr_reader :children
      attr_accessor :value

      def initialize(value = NO_VALUE)
        @value = value
        @children = {}
      end

      def each_child
        if block_given?
          children.each_pair { |key, child| yield key, child }
        else
          children.each
        end
      end

      def has_children?
        !children.empty?
      end

      def has_child?(key)
        children.include?(key)
      end

      def child_at(key)
        children[key]
      end

      def add_child(key, node)
        @children[key] = node
      end

      def has_value?
        value != NO_VALUE
      end
    end

  end
end
