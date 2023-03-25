module Api
  module V1
    module Reports
      class GetKeywordHtmlString
        prepend SimpleCommand
        prepend SimpleResponse

        def initialize(keyword_value)
          @keyword_value = keyword_value
        end

        def call
          options = Selenium::WebDriver::Chrome::Options.new
          options.add_argument('headless')
          options.add_argument("--user-agent=#{user_agent}")

          client = Selenium::WebDriver::Remote::Http::Default.new
          client.read_timeout = 180

          driver = Selenium::WebDriver.for(:chrome, http_client: client, options: options)

          ws = window_size
          target_size = Selenium::WebDriver::Dimension.new(ws[0], ws[1])
          driver.manage.window.size = target_size

          driver.get("https://www.google.com/search?q=#{URI.encode(keyword_value)}")
          source = driver.page_source

          # driver.execute_script('return navigator.userAgent')
          # driver.manage.window.size

          driver.quit

          source
        end

        private

        def user_agent
          Api::V1::Reports::GetUserAgents.instance.random_user_agent
        end

        def window_size
          window_sizes.sample
        end

        def window_sizes
          @window_sizes ||=
            [
              [1600, 900],
              [1680, 1050],
              [1920, 1080],
              [1920, 1200],
              [2560, 1600]
            ]
        end

        attr_reader :keyword_value
      end
    end
  end
end
