require 'rails_helper'

RSpec.describe FetchKeywordsWorker, type: :worker do
  describe '#perform' do
    let(:report_id) { 1 }

    it 'calls FetchKeywords service' do
      expect(Api::V1::Reports::FetchKeywords).to receive(:call).with(report_id)
      subject.perform(report_id)
    end
  end
end
