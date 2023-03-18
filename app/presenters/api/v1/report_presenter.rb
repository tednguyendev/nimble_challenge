module Api
  module V1
    class ReportPresenter < BasePresenter
      def to_json(opts = {})
        {
          id: entity.id,
          name: entity.name,
          status: entity.status,
          percentage: entity.percentage,
          created_at: entity.created_at.strftime('%Y-%m-%d %H:%M:%S'),
        }
      end
    end
  end
end
