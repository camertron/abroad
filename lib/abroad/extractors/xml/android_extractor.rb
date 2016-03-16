require 'nokogiri'
require 'ext/htmlentities/android_xml_decoder'

module Abroad
  module Extractors
    module Xml

      class AndroidExtractor < XmlExtractor
        private

        def each_entry(&block)
          doc = parse
          each_string_entry(doc, &block)
          each_array_entry(doc, &block)
          each_plural_entry(doc, &block)
        end

        def each_string_entry(doc)
          doc.xpath('//string').each do |node|
            yield name_from(node), text_from(node)
          end
        end

        def each_array_entry(doc)
          doc.xpath('//string-array').each do |array|
            prefix = name_from(array)

            array.xpath('item').each_with_index do |item, idx|
              yield "#{prefix}.#{idx}", text_from(item)
            end
          end
        end

        def each_plural_entry(doc)
          doc.xpath('//plurals').each do |plurals|
            prefix = name_from(plurals)

            plurals.xpath('item').each do |item|
              quantity = item.attributes['quantity'].value
              yield "#{prefix}.#{quantity}", text_from(item)
            end
          end
        end

        def text_from(node)
          builder = Nokogiri::XML::Builder.new do |builder|
            builder.root do
              node.children.each do |child|
                serialize(child, builder)
              end
            end
          end

          # safe to call `strip` after `to_xml` because any string that
          # needs leading or trailing whitespace preserved should be wrapped
          # in double quotes
          unescape(
            strip_enclosing_quotes(
              builder.doc.xpath('/root/node()').to_xml.strip
            )
          )
        end

        def serialize(node, builder)
          if node.text?
            builder.text(unescape(node.text))
          else
            builder.send("#{node.name}_", node.attributes) do
              node.children.each do |child|
                serialize(child, builder)
              end
            end
          end
        end

        def name_from(node)
          if attribute = node.attributes['name']
            attribute.value
          end
        end

        def unescape(text)
          text = text
            .gsub("\\'", "'")
            .gsub('\\"', '"')
            .gsub("\\n", "\n")
            .gsub("\\r", "\r")
            .gsub("\\t", "\t")

          coder.decode(text)
        end

        def coder
          @coder ||= HTMLEntities::AndroidXmlDecoder.new
        end

        def strip_enclosing_quotes(text)
          quote = case text[0]
            when "'", '"'
              text[0]
          end

          if quote
            text.gsub(/\A#{quote}(.*)#{quote}\z/) { $1 }
          else
            text
          end
        end
      end

    end
  end
end
