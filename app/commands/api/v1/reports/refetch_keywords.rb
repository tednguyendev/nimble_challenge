module Api
  module V1
    module Reports
      class RefetchKeywords
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(opts = {})
          @id = opts[:id]
          @current_user = opts[:current_user]
        end

        def call
          return response(message: 'Report not exists.') if report_not_exists?

          ActiveRecord::Base.transaction do
            update_report_status
            update_keywords_status
          end

          refetch_keywords

          response
        rescue StandardError => e
          response(message: e.to_s)
        end

        private

        attr_reader :id, :current_user

        def update_report_status
          report.update!(status: Report::PENDING)
        end

        def update_keywords_status
          report.keywords
                .where(status: :failed)
                .each { |r| r.update!(status: Keyword::PENDING) }
        end

        def refetch_keywords
          FetchKeywordsWorker.perform_async(report.id)
        end

        def report_not_exists?
          report.nil?
        end

        def report
          @report ||= current_user.reports.find_by(id: id, status: :failed)
        end
      end
    end
  end
end
