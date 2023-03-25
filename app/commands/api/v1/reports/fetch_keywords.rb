module Api
  module V1
    module Reports
      class FetchKeywords
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(report_id)
          @report_id = report_id
        end

        def call
          return unless report.pending?

          keyword_ids.in_groups_of(10).each do |group|
            sleep(long_delay)

            group.compact.each do |keyword_id|
              sleep(short_delay)
              FetchKeywordWorker.perform_async(keyword_id)
            end
          end
        end

        private

        def report
          @report ||= Report.find_by(id: report_id)
        end

        def keyword_ids
          @keyword_ids ||=
            report.keywords
                  .where(status: Report::PENDING)
                  .order_by_created_at_ascending
                  .ids
        end

        def long_delay
          # to create some randomness, fake human behavior
          rand(3.1..4.1).round(1)
        end

        def short_delay
          # to create some randomness, fake human behavior
          rand(3.0..4.0).round(1)
        end

        attr_reader :report_id
      end
    end
  end
end
