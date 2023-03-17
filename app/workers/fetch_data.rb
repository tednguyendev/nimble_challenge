class FetchData
  include Sidekiq::Worker

  def perform(report_id)
    Api::V1::Google::FetchKeywords.call(report_id)
  end
end