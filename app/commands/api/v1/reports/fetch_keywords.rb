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

          keywords.in_groups_of(10).each do |group|
            sleep(long_delay)

            group.compact.each do |keyword|
              unless keyword.success?
                status = fetch(keyword)
                return handle_false unless status
              end
            end
          end

          send_report_status_mail
        end

        private

        def report
          @report ||= Report.find_by(id: report_id)
        end

        def keywords
          @keywords ||=
            report.keywords
                  .where(status: Report::PENDING)
                  .order_by_created_at_ascending
        end

        def long_delay
          # to create some randomness, fake human behavior
          rand(3.1..4.1).round(1)
        end

        def short_delay
          # to create some randomness, fake human behavior
          rand(2.0..3.0).round(1)
        end

        def fetch(keyword)
          html_string = get_page_source(keyword)
          doc = Nokogiri::HTML(html_string)

          if doc.css('#captcha-form').length >= 1
            keyword.update(status: Keyword::FAILED)
            return false
          end

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

        def get_page_source(keyword)
          options = Selenium::WebDriver::Chrome::Options.new
          options.add_argument('headless')
          options.add_argument("--user-agent=#{user_agent}}")
          driver = Selenium::WebDriver.for(:chrome, options: options)

          sleep(short_delay)

          driver.get("https://www.google.com/search?q=#{URI.encode(keyword.value)}")
          source = driver.page_source
          # driver.execute_script('return navigator.userAgent')
          driver.quit

          source
        end

        def user_agent
          user_agents.rotate!
          user_agents.first
        end

        def user_agents
          @user_agents ||= Api::V1::Reports::GetUserAgents.call.result
        end

        def handle_false
          report.update(status: Report::FAILED)

          send_report_status_mail
        end

        def send_report_status_mail
          ReportMailer.report_status(report_id).deliver_later
        end

        attr_reader :report_id
      end
    end
  end
end
