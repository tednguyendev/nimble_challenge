module Api
  module V1
    module Reports
      class Get
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(opts = {})
          @id = opts[:id]
          @current_user = opts[:current_user]
        end

        def call
          return response(message: 'Report not exists.') if report_not_exists?

          response(
            data: {
              record: Api::V1::DetailReportPresenter.json(report)
            }
          )
        end

        private

        attr_reader :id, :current_user

        def report_not_exists?
          report.nil?
        end

        def report
          @report = current_user.reports.find_by_id(id)
        end
      end
    end
  end
end
