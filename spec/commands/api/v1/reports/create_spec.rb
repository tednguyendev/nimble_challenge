require 'rails_helper'

RSpec.describe Api::V1::Reports::Create, type: :model do
  describe '#call' do
    let(:params) do
      {
        name: 'ted',
        file: File.open(csv_file_path, 'r'),
        current_user: create(:user)
      }
    end
    let(:csv_file_path) { Rails.root.join('spec', 'mocks', 'dog.png') }

    # let(:google_search_response) do
    #   VCR.use_cassette("google/searches_2") { GoogleScrape::Search.fetch_results(CSV.parse(File.open(csv_file_path, 'r').read).flatten) }
    # end

    # before do
    #   allow_any_instance_of(described_class).to receive(:fetch_all).and_return(google_search_response)
    # end

    it 'test' do
      # a1 = Time.now
      cmd = described_class.call(params)
      # a2 = Time.now
      # p('==============')
      # p('==============')
      # p('==============')
      # p('==============')
      # p('===ad_words_count===')
      # p(Keyword.pluck(:ad_words_count))
      # p('===links_count===')
      # p(Keyword.pluck(:links_count))
      # p('===total_results===')
      # p(Keyword.pluck(:total_results))
      # p('===search_time===')
      # p(Keyword.pluck(:search_time))
      # p(a2 - a1)
      p(Keyword.count)

      expect(cmd.success?).to be(true)
    end
  end
end
