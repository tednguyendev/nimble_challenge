class FetchKeywordWorker
  include Sidekiq::Worker

  def perform(keyword_id)
    Api::V1::Reports::FetchKeyword.call(keyword_id)
  end
end