module Api
  module V1
    module Google
      class FetchKeywords
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(report_id)
          @report_id = report_id
        end

        def call
          keywords.in_groups_of(10).each do |group|
            gr = group.compact
            sleep(long_delay)

            gr.each do |keyword|
              fetch(keyword) unless keyword.success?
            end
          end
        end

        private

        def report
          @report ||= Report.find_by(id: report_id)
        end

        def keywords
          @keywords ||= report.keywords
        end

        def long_delay
          # to create some randomness, fake human behavior
          rand(0.4..2.4).round(1)
        end

        def short_delay
          # to create some randomness, fake human behavior
          rand(0.2..1.2).round(1)
        end

        def fetch(keyword)
          options = Selenium::WebDriver::Chrome::Options.new
          options.add_argument('headless')
          driver = Selenium::WebDriver.for(:chrome, options: options)

          sleep(short_delay)
          driver.get "https://www.google.com/search?q=#{URI.encode(keyword.value)}"
          html_string = driver.page_source
          driver.quit

          doc = Nokogiri::HTML(html_string)

          total_results = nil
          search_time = nil

          result_stats_text = doc.css('#result-stats').text.strip

          if result_stats_text.length.positive?
            result_stats_ary = result_stats_text.split(" ")
            total_results = result_stats_ary[1].gsub(".",",").gsub(",","").to_i
            search_time = result_stats_ary[-2].gsub("(","").gsub(",",".").to_f
          end

          ad_words_count = doc.xpath('//*[@class="U3A9Ac qV8iec"]').count
          links_count = doc.css('a').map { |l| l['href'] }.select { |l| l.is_a?(String) && "http".in?(l) && !".google.com".in?(l) }.uniq.count

          keyword.update(
            ad_words_count: ad_words_count,
            links_count: links_count,
            total_results: total_results,
            search_time: search_time,
            html_string: html_string,
            status: :success
          )
        end

        def user_agent
          user_agents.rotate!
          user_agents.first
        end

        def user_agents
          @user_agents ||= Api::V1::Google::GetUserAgents.call.result
        end

        attr_reader :report_id
      end
    end
  end
end
