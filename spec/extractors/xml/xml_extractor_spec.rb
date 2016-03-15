require 'spec_helper'

describe 'XmlExtractor' do
  fixture_dir = File.expand_path('./', File.dirname(__FILE__))
  it_behaves_like 'a fixture-based extractor', fixture_dir, Abroad::Extractors::Xml
end
