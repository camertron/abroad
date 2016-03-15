module Abroad
  class SyntaxError < StandardError; end
  autoload :Extractors,  'abroad/extractors'
  autoload :Serializers, 'abroad/serializers'
end
