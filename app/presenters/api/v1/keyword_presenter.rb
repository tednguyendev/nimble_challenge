module Api
  module V1
    class KeywordPresenter < BasePresenter
      def to_json(opts = {})
        {
          id: entity.id,
          created_at: entity.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          value: entity.value,
          ad_words_count: entity.ad_words_count,
          links_count: entity.links_count,
          total_results: entity.total_results,
          search_time: entity.search_time,
          status: entity.status,
          origin_page: "https://www.google.com/search?q=#{URI.encode(entity.value)}"
          # html_string
        }
      end
    end
  end
end
