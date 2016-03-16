require 'spec_helper'

describe Abroad do
  describe '.extractors' do
    it 'lists all the registered extractors' do
      extractors = Abroad.extractors
      expect(extractors).to be_a(Array)
      expect(extractors).to include('yaml/rails')
    end
  end

  describe '.serializers' do
    it 'lists all the registered serializers' do
      serializers = Abroad.serializers
      expect(serializers).to be_a(Array)
      expect(serializers).to include('yaml/rails')
    end
  end

  describe '.extractor' do
    it 'retrieves the extractor class by id' do
      expect(Abroad.extractor('yaml/rails')).to eq(
        Abroad::Extractors::Yaml::RailsExtractor
      )
    end
  end

  describe '.serializer' do
    it 'retrieves the serializer class by id' do
      expect(Abroad.serializer('yaml/rails')).to eq(
        Abroad::Serializers::Yaml::RailsSerializer
      )
    end
  end
end
