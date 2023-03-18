module Api
  module V1
    module Reports
      class List
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(opts = {})
          @opts = opts
          @current_user = @opts.delete(:current_user)
        end

        def call
          response(
            data: {
              records: Api::V1::ReportPresenter.json(reports),
              page: reports.current_page,
              per_page: reports.limit_value,
              next_page: reports.next_page,
              total_pages: reports.total_pages,
              total: reports.total_count
            }
          )
        end

        private

        attr_reader :opts, :current_user

        def reports
          return @reports unless @reports.nil?

          reports = records
          reports = filter(reports)
          reports = order(reports)
          reports = paginate(reports)

          @reports = reports
        end

        def paginate(reports)
          reports.page(opts[:page])
                 .per(opts[:per_page])
        end

        def filter(reports)
          return reports unless opts[:keyword].present?

          reports.joins(:keywords)
                 .where("reports.name LIKE ? OR keywords.value LIKE ?", "%#{opts[:keyword]}%", "%#{opts[:keyword]}%")
                 .distinct
        end

        def order(reports)
          case opts[:order_by]
          when 'name_descending'
            reports.order_by_name_descending
          when 'name_ascending'
            reports.order_by_name_ascending
          when 'created_at_descending'
            reports.order_by_created_at_descending
          when 'created_at_ascending'
            reports.order_by_created_at_ascending
          when 'status_descending'
            reports.order_by_status_descending
          when 'status_ascending'
            reports.order_by_status_ascending
          when 'percentage_descending'
            reports.order_by_percentage_descending
          when 'percentage_ascending'
            reports.order_by_percentage_ascending
          else
            reports.order_by_created_at_descending
          end
        end

        def records
          @records ||=
            current_user.reports
        end
      end
    end
  end
end
