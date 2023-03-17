module Api
  module V1
    module Google
      class FetchResultsSavers
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(opts = {})
          @file = opts[:file]
        end

        def call
          byebug
          # driver = Selenium::WebDriver.for :chrome
          options = Selenium::WebDriver::Chrome::Options.new
          driver = Selenium::WebDriver.for(:chrome)

          driver.get "https://www.google.com/search?q=what+is+a+house&rlz=1C5CHFA_enVN958VN958&oq=what&aqs=chrome.0.69i59j69i57j69i59l2j69i61l2j69i60l2.697j0j9&sourceid=chrome&ie=UTF-8"
          doc = Nokogiri::HTML(driver.page_source)

          result_stats_text = doc.css('#result-stats').text.strip
          result_stats_ary = result_stats_text.split(" ")
          result_count = result_stats_ary[1].gsub(",","").to_i
          query_time = result_stats_ary[-2].gsub("(","").to_f

          # html = fetch_all.first.body
          # doc = Nokogiri::HTML(html)
          # doc.css('script').remove                             # Remove <script>…</script>
          # doc.xpath("//@*[starts-with(name(),'on')]").remove

          # doc.css('a').map { |l| l['href']  }.select { |l| "/url?".in?(l) }.map { |l| l.gsub(/.*q=/, "").split('&').first }.count
          doc.css('a').map { |l| l['href'] }.select { |l| l.is_a?(String) && "http".in?(l) && !".google.com".in?(l) }.count
          html
          byebug
        end

        private

        def keywords
          @keywords ||= CSV.parse(file.read).flatten
        end

        def fetch_all
          GoogleScrape::Search.fetch_results(keywords)
        end

        attr_reader :file
      end
    end
  end
end
