require 'rails_helper'

RSpec.describe Api::V1::Google::FetchResultsSavers, type: :model do
  describe '#call' do
    let(:params) do
      { file: file }
    end
    let(:csv_file_path) { Rails.root.join('spec', 'mocks', 'test_data_2.csv') }
    let(:file) { File.open(csv_file_path, 'r') }
    let(:keywords) { CSV.parse(file.read).flatten }

    let(:google_search_response) do
      VCR.use_cassette("google/searches_2") { GoogleScrape::Search.fetch_results(keywords) }
    end

    before do
      allow_any_instance_of(described_class).to receive(:fetch_all).and_return(google_search_response)
    end

    it 'test' do
      cmd = described_class.call(params)
      p cmd.result

      expect(cmd.success?).to be(true)
    end
  end
end
