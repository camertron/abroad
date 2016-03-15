require 'htmlentities'

class HTMLEntities
  MAPPINGS['android_xml'] = MAPPINGS['xhtml1'].dup.tap do |mappings|
    mappings.delete('apos')
  end

  FLAVORS << 'android_xml'

  class AndroidXmlDecoder < Decoder
    def initialize
      super('android_xml')
    end
  end
end
