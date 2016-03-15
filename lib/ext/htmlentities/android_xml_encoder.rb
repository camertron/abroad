require 'htmlentities'

class HTMLEntities
  MAPPINGS['android_xml'] = MAPPINGS['xhtml1'].dup.tap do |mappings|
    mappings.delete('apos')
  end

  FLAVORS << 'android_xml'

  class AndroidXmlEncoder < Encoder
    def initialize(instructions = [])
      super('android_xml', instructions)
    end

    private

    # had to adjust this so that single and double quotes don't get turned into
    # entities (they're escaped by hand with backslashes)
    def basic_entity_regexp
      @basic_entity_regexp ||= /[&]/
    end
  end
end
