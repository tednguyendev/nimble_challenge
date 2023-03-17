module Api
  module V1
    module Google
      class FetchResultsSavers
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(opts = {})
          @file = opts[:file]
          @current_user = opts[:current_user]
        end

        def call
          @report = Report.create(user: current_user)

          options = Selenium::WebDriver::Chrome::Options.new
          options.add_argument('headless')
          @driver = Selenium::WebDriver.for(:chrome, options: options)

          keywords.each do |keyword|
            fetch(keyword)
          end

          byebug
          @driver.quit
        end

        private

        def keywords
          @keywords ||= CSV.parse(file.read).flatten
        end

        def fetch_all
          GoogleScrape::Search.fetch_results(keywords)
        end

        def fetch(keyword)
          @driver.get "https://www.google.com/search?q=#{URI.encode(keyword)}"
          html_string = @driver.page_source
          doc = Nokogiri::HTML(html_string)

          total_results = 0
          search_time = 0

          result_stats_text = doc.css('#result-stats').text.strip

          if result_stats_text.length.positive?
            result_stats_ary = result_stats_text.split(" ")
            total_results = result_stats_ary[1].gsub(".",",").gsub(",","").to_i
            search_time = result_stats_ary[-2].gsub("(","").gsub(",",".").to_f
          end

          ad_words_count = doc.xpath('//*[@class="U3A9Ac qV8iec"]').count
          links_count = doc.css('a').map { |l| l['href'] }.select { |l| l.is_a?(String) && "http".in?(l) && !".google.com".in?(l) }.uniq.count

          Keyword.create(
            value: keyword,
            report: @report,
            ad_words_count: ad_words_count,
            links_count: links_count,
            total_results: total_results,
            search_time: search_time,
            html_string: html_string
          )
        end

        attr_reader :file, :current_user
      end
    end
  end
end
