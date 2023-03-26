require 'rails_helper'

RSpec.describe Api::V1::Reports::ParseHtmlString do
  subject(:command) { described_class.new(html_string) }

  context 'given an html string without a captcha' do
    let(:html_string) { File.open(Rails.root.join('spec', 'mocks', 'crawl_api_google.html'), 'r').read }

    it 'returns a hash with total results, search time, ad words count, and links count' do
      expect(subject.call.result).to eq({
        have_captcha: false,
        data: {
          ad_words_count: 3,
          links_count: 170,
          total_results: 15000000,
          search_time: 0.59
        }
      })
    end
  end

  context 'given an html string with a captcha' do
    let(:html_string) { File.open(Rails.root.join('spec', 'mocks', 'capcha.html'), 'r').read }

    it 'returns a hash with a have_captcha key set to true' do
      expect(subject.call.result).to eq({ have_captcha: true })
    end
  end
end
