require 'rails_helper'

RSpec.describe Api::V1::Google::FetchResults, type: :model do
  describe '#call' do
    let(:params) do
      { file: file }
    end
    let(:csv_file_path) { Rails.root.join('spec', 'mocks', 'test_data_100.csv') }
    let(:file) { File.open(csv_file_path, 'r') }

    let(:max_keywords) { 100 }

    let(:keywords) do
      (1..max_keywords).to_a.map do |i|
        "string#{i}"
      end
    end

    # let(:google_search_response) do
    #   VCR.use_cassette("google/searches_100") { GoogleScrape::Search.fetch_results(keywords) }
    # end

    # before do
    #   allow_any_instance_of(described_class).to receive(:ait).and_return(google_search_response)
    # end

    it 'test' do
      cmd = described_class.call(params)
      p cmd.result

      expect(cmd.success?).to be(true)
    end
  end
end
