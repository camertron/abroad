require 'htmlentities'
require 'ext/htmlentities/android_xml_encoder'

module Abroad
  module Serializers
    module Xml

      class AndroidSerializer < XmlSerializer
        PLURAL_FORMS = %w(
          zero one two few many other
        )

        attr_reader :plurals, :arrays

        def after_initialize
          writer.open_tag('resources')
          @plurals = Hash.new { |hash, key| hash[key] = {} }
          @arrays = Hash.new { |hash, key| hash[key] = {} }
        end

        def write_raw(text)
          stream.write(text)
        end

        def write_key_value(key, value)
          key_parts = split_key(key)

          case detect_string_type(key_parts)
            when :plural
              record_plural(key_parts, value)
            when :array_element
              record_array_element(key_parts, value)
            else
              write_string(key, value)
          end
        end

        def flush
          write_recorded_plurals
          write_recorded_arrays
          writer.flush
          stream.flush
        end

        private

        def split_key(key)
          if idx = key.rindex('.')
            [key[0..(idx - 1)], key[(idx + 1)..-1]]
          else
            # this case should never happen
            [key, '']
          end
        end

        def record_plural(key_parts, value)
          plurals[key_parts.first][key_parts.last] = value
        end

        def record_array_element(key_parts, value)
          arrays[key_parts.first][key_parts.last.to_i] = value
        end

        def write_plural(name, plural_forms)
          writer.open_tag(:plurals, name: name)

          plural_forms.each_pair do |quantity, value|
            writer.open_single_line_tag(:item, quantity: quantity)
            write_text(value)
            writer.close_tag
          end

          writer.close_tag
        end

        def write_array(name, array_elements)
          writer.open_tag(:'string-array', name: name)
          count = array_elements.keys.max

          (0..count).each do |i|
            writer.open_single_line_tag(:item)
            write_text(array_elements[i] || '')
            writer.close_tag
          end

          writer.close_tag
        end

        def write_recorded_plurals
          plurals.each_pair do |name, plural_forms|
            write_plural(name, plural_forms)
          end
        end

        def write_recorded_arrays
          arrays.each_pair do |name, array_elements|
            write_array(name, array_elements)
          end
        end

        def write_string(key, value)
          writer.open_single_line_tag(:string, name: key)
          write_text(value)
          writer.close_tag
        end

        def write_text(text)
          escaped_text = escape(text)
          writer.write_text(
            escaped_text, escape: false
          )
        end

        def detect_string_type(key_parts)
          last_part = key_parts.last

          if PLURAL_FORMS.include?(last_part)
            :plural
          elsif last_part =~ /\A[\d]+\z/
            :array_element
          else
            :string
          end
        end

        def escape(text)
          text.gsub!("\n", "\\n")                    # escape literal newlines
          text.gsub!("\r", "\\r")                    # escape literal carriage returns
          text.gsub!("\t", "\\t")                    # escape literal tabs
          text.gsub!(/([^\\]?)(')/) { "#{$1}\\'" }   # escape single quotes
          text.gsub!(/([^\\]?)(")/) { "#{$1}\\\"" }  # escape double quotes

          coder.encode(text)
        end

        def coder
          @coder ||= HTMLEntities::AndroidXmlEncoder.new
        end
      end

    end
  end
end
