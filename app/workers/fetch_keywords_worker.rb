class FetchKeywordsWorker
  include Sidekiq::Worker

  def perform(report_id)
    Api::V1::Reports::FetchKeywords.call(report_id)
  end
end