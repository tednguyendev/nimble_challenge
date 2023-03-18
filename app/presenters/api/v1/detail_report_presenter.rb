module Api
  module V1
    class DetailReportPresenter < BasePresenter
      def to_json(opts = {})
        {
          id: entity.id,
          name: entity.name,
          status: entity.status,
          percentage: entity.percentage,
          created_at: entity.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          keywords: Api::V1::KeywordPresenter.json(entity.keywords)
        }
      end
    end
  end
end
