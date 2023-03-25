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
          # if keyword_id == 2933
          #   keyword.update(status: Keyword::FAILED)
          #   raise 'a'
          # end

          return unless keyword

          html_string = get_page_source
          # html_string = File.open(Rails.root.join('spec', 'mocks', 'capcha.html'), 'r').read
          doc = Nokogiri::HTML(html_string)

          if doc.css('#captcha-form').length >= 1
            keyword.update(status: Keyword::FAILED)
          else
            total_results, search_time = get_total_results_and_search_time(doc)
            ad_words_count = get_ad_words_count(doc)
            links_count = get_links_count(doc)

            keyword.update(
              ad_words_count: ad_words_count,
              links_count: links_count,
              total_results: total_results,
              search_time: search_time,
              html_string: html_string,
              status: Keyword::SUCCESS
            )
          end

          update_report
        end

        private

        def keyword
          @keyword ||=
            Keyword.where(id: keyword_id)
                   .where.not(status: Keyword::SUCCESS)
                   .first
        end

        def report
          @report ||= keyword.report
        end

        def get_total_results_and_search_time(doc)
          total_results = nil
          search_time = nil

          result_stats_text = doc.css('#result-stats').text.strip

          if result_stats_text.length.positive?
            result_stats_ary = result_stats_text.split(" ")
            total_results = result_stats_ary[1].gsub(".",",").gsub(",","").to_i
            search_time = result_stats_ary[-2].gsub("(","").gsub(",",".").to_f
          end

          [total_results, search_time]
        end

        def get_ad_words_count(doc)
          normal_ads_count = doc.css('.U3A9Ac.qV8iec').count

          # sometimes there are 2 of them, but only show 1 in the page
          shopping_ads_count = doc.css('.fryEeb.U3A9Ac.irmCpc').count > 0 ? 1 : 0
          normal_ads_count + shopping_ads_count
        end

        def get_links_count(doc)
          doc.css('a')
             .map { |l| l['href'] }
             .select { |l| l.is_a?(String)}
             .uniq
             .count
             #  .select { |l| l.is_a?(String) && "http".in?(l) && !".google.com".in?(l) }
        end

        def get_page_source
          options = Selenium::WebDriver::Chrome::Options.new
          options.add_argument('headless')
          options.add_argument("--user-agent=#{user_agent}}")
          driver = Selenium::WebDriver.for(:chrome, options: options)

          ws = window_size
          target_size = Selenium::WebDriver::Dimension.new(ws[0], ws[1])
          driver.manage.window.size = target_size

          driver.get("https://www.google.com/search?q=#{URI.encode(keyword.value)}")
          source = driver.page_source

          # driver.execute_script('return navigator.userAgent')
          # driver.manage.window.size

          driver.quit

          source
        end

        def user_agent
          user_agents.sample
        end

        def user_agents
          @user_agents ||= Api::V1::Reports::GetUserAgents.call.result
        end

        def window_size
          window_sizes.sample
        end

        def window_sizes
          @window_sizes ||=
            [
              # [1280, 800],
              # [1366, 768],
              # [1440, 900],
              [1600, 900],
              [1680, 1050],
              [1920, 1080],
              [1920, 1200],
              [2560, 1600]
            ]
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

          success_keywords_count = report.keywords.where(status: Report::SUCCESS).count

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