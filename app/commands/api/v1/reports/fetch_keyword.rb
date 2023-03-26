module Api
  module V1
    module Reports
      class FetchKeyword
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(keyword_id)
          @keyword_id = keyword_id
        end

        def call
          return unless keyword

          begin
            fetch_and_update_keyword
          rescue Exception => e
            print("========>e : ", e)
            mark_keyword_as_failed
          ensure
            update_report
          end
        end

        private

        def fetch_and_update_keyword
          html_string = get_html_string
          result = parse_html_string(html_string)

          if result[:have_captcha]
            raise 'captcha'
          else
            keyword.update(
              ad_words_count: result[:data][:ad_words_count],
              links_count: result[:data][:links_count],
              total_results: result[:data][:total_results],
              search_time: result[:data][:search_time],
              html_string: html_string,
              status: Keyword::SUCCESS
            )
          end
        end

        def parse_html_string(html_string)
          ParseHtmlString.call(html_string).result
        end

        def get_html_string
          GetKeywordHtmlString.call(keyword.value).result
        end

        def mark_keyword_as_failed
          keyword.update(status: Keyword::FAILED)
        end

        def keyword
          @keyword ||=
            Keyword.where(id: keyword_id)
                   .where.not(status: Keyword::SUCCESS)
                   .first
        end

        def report
          @report ||= keyword.report
        end

        def update_report
          report.percentage = percentage
          report.status = status

          if report.status_changed?
            ReportMailer.report_status(report.id).deliver_later
          end

          report.save
        end

        def percentage
          keywords_count = report.keywords.count

          success_keywords_count = report.keywords.where.not(status: Report::PENDING).count

          (success_keywords_count.to_f / keywords_count) * 100
        end

        def status
          pending_keywords_count = report.keywords.where(status: Report::PENDING).count
          failed_keywords_count = report.keywords.where(status: Report::FAILED).count

          if report.pending? && pending_keywords_count.zero?
            if failed_keywords_count.zero?
              Report::SUCCESS
            else
              Report::FAILED
            end
          else
            report.status
          end
        end

        attr_reader :keyword_id
      end
    end
  end
end
