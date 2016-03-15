require 'spec_helper'

describe 'JsonExtractor' do
  fixture_dir = File.expand_path('./', File.dirname(__FILE__))
  it_behaves_like 'a fixture-based extractor', fixture_dir, Abroad::Extractors::Json
end
